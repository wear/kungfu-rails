class Mailer < ActionMailer::Base
  def signup_notification(attendee)
    setup_email(attendee)
    @subject    += '您的参会信息已收到，请尽快完成支付'
  end
  
  def ticket(attendee)
    setup_email(attendee)
    @subject    += '您的电子门票,请打印或凭身份证于参会号准时参会!'
  end
  
  protected
    def setup_email(attendee)
      @recipients   = "#{attendee.email}"
      @bcc          = "team@zoomtype.info"
      @from         = "KungfuRails 09<account@zoomtype.info>"
      @subject      = "[KungfuRails 09] "
      @sent_on      = Time.now
      @content_type = "text/html"
      @body[:attendee] = attendee
    end
end
