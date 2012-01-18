class DisplayController < ApplicationController
  ACTIVE = "class='active'"
  layout "navigation", :except => [:index]

  def index
    render :layout => "application"
  end

  def register
    redirect_to "/" and return if session[:at].nil?
    @register_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    @client = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    @zona = @usuario.zonas.first
    @invitaciones_recibidas = []
    @invitaciones_enviadas = []

  end

  def home
    redirect_to "/" and return if session[:at].nil?
    @home_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    @recomendados = Usuario.busqueda(@usuario.facebook_id, params[:limit], params[:interes_id])
    @invitaciones_recibidas = Invitacion.find(:all, :conditions => ["usuario_para_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
    @invitaciones_enviadas = Invitacion.find(:all, :conditions => ["usuario_desde_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
  end
  
  def myprofile
    redirect_to "/" and return if session[:at].nil?
    @myprofile_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    @invitaciones_recibidas = Invitacion.find(:all, :conditions => ["usuario_para_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
    @invitaciones_enviadas = Invitacion.find(:all, :conditions => ["usuario_desde_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
    intereses = @usuario.intereses
    @intereses_music = intereses.find_all{|interes| interes.categoria == 'Musician/band'}
    @intereses_movies = intereses.find_all{|interes| interes.categoria == 'Movie'}
    @intereses_tv = intereses.find_all{|interes| interes.categoria == 'Tv show'}
    @intereses_books = intereses.find_all{|interes| interes.categoria == 'Book'}
    @intereses_other = intereses.find_all{|interes| interes.categoria == 'Interest' or interes.categoria. == 'Sport'}
    @zona = @usuario.zonas.first
  end

  def profile
    redirect_to "/" and return if session[:at].nil?
    @usuario = Usuario.find(session[:usuario_id])
    @usuario_perfil = Usuario.find(params[:id])
    intereses = @usuario_perfil.intereses
    @intereses_music = intereses.find_all{|interes| interes.categoria == 'Musician/band'}
    @intereses_movies = intereses.find_all{|interes| interes.categoria == 'Movie'}
    @intereses_tv = intereses.find_all{|interes| interes.categoria == 'Tv show'}
    @intereses_books = intereses.find_all{|interes| interes.categoria == 'Book'}
    @intereses_other = intereses.find_all{|interes| interes.categoria == 'Interest' or interes.categoria. == 'Sport'}
    @invitaciones_recibidas = Invitacion.find(:all, :conditions => ["usuario_para_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
    @invitaciones_enviadas = Invitacion.find(:all, :conditions => ["usuario_desde_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")

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
