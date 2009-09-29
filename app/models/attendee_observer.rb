class AttendeeObserver < ActiveRecord::Observer
  def after_create(attendee)
    Mailer.deliver_signup_notification(attendee)
  end
end
