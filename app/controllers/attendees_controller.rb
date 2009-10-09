class AttendeesController < ApplicationController
  include AuthenticatedSystem    
  before_filter :login_required, :only => [:index]
  access_control :index => 'superuser'
  before_filter { |c| c.set_section('register') }
  
  # GET /attendees
  # GET /attendees.xml
  def index
    @attendees = Attendee.paginate(:page => params[:page], :per_page => 40)
    respond_to do |format| 
      format.html # index.html.erb
      format.xml  { render :xml => @attendees }
    end
  end

  # GET /attendees/1
  # GET /attendees/1.xml
  def show
    @attendee = Attendee.find_by_slug_url(params[:id])
    
    respond_to do |format|
      format.html 
    end
  end

  # GET /attendees/new
  # GET /attendees/new.xml
  def new  
    @step = 1
    @attendee = Attendee.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /attendees
  # POST /attendees.xml
  def create
    @attendee = Attendee.new(params[:attendee])

    respond_to do |format|
      if @attendee.save
        flash[:notice] = '参会人注册成功,相关信息已发送到您的邮箱!'
        format.html { redirect_to(@attendee) }
      else 
        @step = 1 
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    @attendee = Attendee.find_by_slug_url(params[:id])
    if @attendee.payment.nil?
      @attendee.build_payment(params[:payment])
    else
      @attendee.payment.update_attributes(params[:payment])
    end
    
    respond_to do |wants|
      if @attendee.payment.save && @attendee.update_attributes(:paid => true) 
        Mailer.deliver_ticket(@attendee)
        flash[:notice] = '支付修改成功'
      else
        flash[:error] = '有错误发生'
      end
      wants.html { redirect_to attendees_path }
    end
  end 
  
  def edit_payment  
    @attendee = Attendee.find_by_slug_url(params[:id])
    @payment =  @attendee.payment.nil? ? @attendee.build_payment : @attendee.payment 
    
    respond_to do |wants|
      wants.html { render :layout => false }
    end
  end
  
  def start_pay
    @attendee = Attendee.find_by_slug_url(params[:id])
	
    respond_to do |format|
      if @attendee.nil?
        flash[:notice] = '对不起，订单不存在'
        format.html {redirect_to :back}
      elsif @attendee.paid
        flash[:notice] = '您的订单已经完成了支付'
        format.html {redirect_to :back}
      else
        tenpay_request = Tenpay::Request.new( 
                'KungfuRails 2009大会门票',
                @attendee.id,
                @template.discount_price(@template.total_fee(@attendee)),
                finish_pay_attendee_url(@attendee, :host => request.host_with_port),
                request.remote_ip
                )
        @attendee.update_attribute(:generated_at, Time.now)
        format.html {redirect_to tenpay_request.url}
      end
    end
  end
  
  def check
    @attendee = Attendee.find_by_slug_url(params[:id])
    
    respond_to do |format| 
      if @attendee && @attendee.paid == false
        query = Tenpay::Query.new(@attendee.id, @attendee.generated_at || Time.now)
        
        if query.response.successful?
          flash[:error] = '支付已成功!'
          Attendee.transaction do 
            @attendee.build_payment(:paid_count => @template.discount_price(@template.total_fee(@attendee)),:payment_type => 'online')
            @attendee.update_attribute(:paid, true)
            Mailer.deliver_ticket(@attendee) 
          end
        else
          flash[:error] = '订单尚未支付!'
        end
        format.html { redirect_to :back }
      elsif @attendee.nil?
        flash[:error] = '对不起，您查询的订单不存在!'
        format.html { redirect_to root_path }
      elsif @attendee.paid
        flash[:error] = '订单支付已成功'
        format.html { redirect_to attendee_path(@attendee) }
      else
        flash[:error] = '支付遇到问题？'
        format.html { redirect_to attendee_path(@attendee) }
      end
    end
  end
  
  def finish_pay
    tenpay_response = Tenpay::Response.new(params)
    @attendee = Attendee.find_by_slug_url(params[:id])
    
    respond_to do |format| 
      if @attendee && @attendee.paid == false && tenpay_response.successful?
        flash[:notice] = '支付已成功!'
        Attendee.transaction do
          @attendee.build_payment(:paid_count => @template.discount_price(@template.total_fee(@attendee)),:payment_type => 'online')
          @attendee.update_attribute(:paid, true)
          Mailer.deliver_ticket(@attendee) 
        end
        format.html { redirect_to attendee_path(@attendee) }
      elsif @attendee.nil?
        flash[:error] = '对不起，您查询的订单不存在!'
        format.html { redirect_to new_attendee_path }
      elsif @attendee.paid
        flash[:error] = '订单支付已成功'
        format.html { redirect_to attendee_path(@attendee) }
      else
        flash[:error] = '支付遇到问题？'
        format.html { redirect_to attendee_path(@attendee) }
      end
    end
  end  
  
  def destroy
    @attendee = Attendee.find_by_slug_url(params[:id])
    @attendee.destroy
     
    flash[:notice] = '已成功删除'
    redirect_to attendees_path    
  end
end
