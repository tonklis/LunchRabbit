class DisplayController < ApplicationController
  ACTIVE = "class='active'"
  layout "navigation", :except => [:index]

  def index
    render :layout => "application"
  end

  def register
  end

  def home
    redirect_to "/" and return unless session[:at]
    @home_active = ACTIVE
    user = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    @usuario = Usuario.encuentra_o_crea(user.id)
  end

  def myprofile
    @myprofile_active = ACTIVE
  end

  def help
    @help_active = ACTIVE
  end

end
