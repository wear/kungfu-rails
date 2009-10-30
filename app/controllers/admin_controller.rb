class AdminController < ApplicationController 
  before_filter :login_required, :only => [:index]
  access_control :index => 'superuser'
  
  def index
    
  end
end
