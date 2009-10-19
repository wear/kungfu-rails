module AttendeesHelper
  def total_fee(attendee)
    price = discount_price(TICKET_PRICE)
    if attendee.number > 1
     attendee.join_party ? (price*0.8 + 5000) * attendee.number : (price*0.8 * attendee.number)
    else
      attendee.join_party ? (price + 5000) : price
    end  
  end  
  
  def discount_price(price)
    new_price = (Date.today < '2009-10-21'.to_date ?  (price - 2000) : price)
  end
  
end
