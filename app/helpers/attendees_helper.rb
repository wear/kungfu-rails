module AttendeesHelper
  def total_fee(attendee)
     attendee.join_party ? 3 : 2
  end  
  
  def discount_price(price)
    new_price = Date.today < '2009-10-21'.to_date ?  (price - 1) : price
    new_price.to_s
  end
end
