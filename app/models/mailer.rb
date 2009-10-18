class Mailer < ActionMailer::Base  
  helper :attendees
  
  def signup_notification(attendee)
    setup_email(attendee)
    @subject    += '您的参会信息已收到，请尽快完成支付'
  end
  
  def ticket(attendee)
    setup_email(attendee)
    @subject    += '您的电子门票,请凭注册名称和参会编号准时参会!'
  end
  
  protected
    def setup_email(attendee)
      @recipients   = "#{attendee.email}"
      @from         = "KungfuRails组委会 <support@kungfurails.com>"
      @subject      = "[KungfuRails 09] "
      @sent_on      = Time.now
      @content_type = "text/html"
      @body[:attendee] = attendee
    end
end
