class DisplayController < ApplicationController
  ACTIVE = "class='active'"
  layout "navigation", :except => [:index]

  def index 
  end

  def register
  end

  def home
    @home_active = ACTIVE
    @usuario = session[:usuario]
  end

  def myprofile
    @myprofile_active = ACTIVE
  end

  def help
    @help_active = ACTIVE
  end

end
