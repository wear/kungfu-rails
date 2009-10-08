module AttendeesHelper
  def total_fee(attendee)
     attendee.join_party ? (TICKET_PRICE + 5000) : TICKET_PRICE
  end  
  
  def discount_price(price)
    new_price = Date.today < '2009-10-21'.to_date ?  (price - 2000) : price
    new_price.to_s
  end
  
end
