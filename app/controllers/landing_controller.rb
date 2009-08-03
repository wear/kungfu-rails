class LandingController < ApplicationController 
  
  def index 
    @section = 'home'
  end
  
  def schedule
    @section = 'schedule'
  end
  
  def tickets
    @section = 'tickets'
  end  
  
  def orgnize
    @section = 'orgnize'
  end 
  
  def sponsors
    @section = 'sponsors'
  end

end
