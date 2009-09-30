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
    @attendee = Attendee.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
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
        format.html { redirect_to(@attendee) }
      else 
        @step = 1 
        format.html { render :action => "new" }
      end
    end
  end
  
  def start_pay
    @attendee = Attendee.find(params[:id])
	
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
                '1',
                finish_pay_attendee_url(@attendee, :host => request.host_with_port),
                request.remote_ip
                )
        @attendee.update_attribute(:generated_at, Time.now)
        format.html {redirect_to tenpay_request.url}
      end
    end
  end
  
  def check
    @attendee = Attendee.find(params[:id])
    
    respond_to do |format| 
      if @attendee && @attendee.paid == false
        query = Tenpay::Query.new(@attendee.id, @attendee.generated_at || Time.now)
        
        if query.response.successful?
          flash[:error] = '支付已成功!'
          @attendee.update_attribute(:paid, true) 
        #  Mailer.deliver_ticket(@attendee)
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
    @attendee = Attendee.find(params[:id])
    
    respond_to do |format| 
      if @attendee && @attendee.paid == false && tenpay_response.successful?
        flash[:notice] = '支付已成功!'
        Attendee.transaction do
          @attendee.update_attribute(:paid, true) 
          deviler
        end
        format.html { redirect_to attendee_path(@attendee) }
      elsif @attendee.nil?
        flash[:error] = '对不起，您查询的订单不存在!'
        format.html { redirect_to new_attendee_path }
      elsif @attendee.paid
        flash[:error] = '您已经支付过此订单'
        format.html { redirect_to attendee_path(@attendee) }
      else
        flash[:error] = '支付遇到问题？'
        format.html { redirect_to attendee_path(@attendee) }
      end
    end
  end
end
