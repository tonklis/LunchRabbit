class DisplayController < ApplicationController
  ACTIVE = "class='active'"
  layout "navigation", :except => [:index]

  def index
    render :layout => "application"
  end

  def register
  end

  def home
    redirect_to "/" and return if session[:at].nil?
    @home_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    @recomendados = Usuario.busqueda(@usuario.facebook_id, 3)
  end
  
  def myprofile
    redirect_to "/" and return if session[:at].nil?
    @myprofile_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    @intereses = @usuario.intereses
    @zona = @usuario.zonas.first
  end

  def help
    @help_active = ACTIVE
  end

  def logout
    session[:at] = nil
    session.delete('at')
    reset_session
    redirect_to "/"
  end

end
