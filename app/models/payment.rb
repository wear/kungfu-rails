class Payment < ActiveRecord::Base 
  belongs_to :attendees, :class_name => "Attendees", :foreign_key => "attendee_id" 
  
  validates_presence_of :paid_count
 
  
end
