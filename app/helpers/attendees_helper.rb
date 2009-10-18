module AttendeesHelper
  def total_fee(attendee)                       
    unless attendee.number > 1
     attendee.join_party ? (discount_price(TICKET_PRICE) + 5000) : TICKET_PRICE
   else
     attendee.join_party ? (discount_price(TICKET_PRICE)*0.8 + 5000)*attendee.number : TICKET_PRICE
   end  
  end  
  
  def discount_price(price)
    new_price = Date.today < '2009-10-21'.to_date ?  (price - 2000) : price
  end
  
end
