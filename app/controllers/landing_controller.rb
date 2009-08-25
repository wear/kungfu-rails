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
  
  def organize
    @section = 'organize'
  end 
  
  def sponsors
    @section = 'sponsors'
  end

end
