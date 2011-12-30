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
    @usuario = Usuario.find(session[:usuario_id])
    @recomendados = Usuario.busqueda(@usuario.facebook_id, 3)
  end

  def myprofile
    redirect_to "/" and return unless session[:at]
    @myprofile_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    client = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    @intereses = client.likes
    @zona = @usuario.zonas.first
  end

  def help
    @help_active = ACTIVE
  end

end
