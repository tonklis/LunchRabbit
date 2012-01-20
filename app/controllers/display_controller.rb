class DisplayController < ApplicationController
  ACTIVE = "class='active'"
  layout "navigation", :except => [:index]

  before_filter :authenticate_usuario!, :except => [:index]

  def index
    render :layout => "application"
  end

  def register
    @register_active = ACTIVE
    @usuario = Usuario.find(current_usuario.id)
    @client = Mogli::User.find("me", Mogli::Client.new(session["devise.at"]))
    @zona = @usuario.zonas.first
    @invitaciones_recibidas = []
    @invitaciones_enviadas = []
  end

  def home
    @home_active = ACTIVE
    @usuario = Usuario.find(current_usuario.id)
    @recomendados = Usuario.busqueda(@usuario.facebook_id, params[:limit], params[:interes_id])
    @invitaciones_recibidas = Invitacion.find(:all, :conditions => ["usuario_para_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
    @invitaciones_enviadas = Invitacion.find(:all, :conditions => ["usuario_desde_id = ? AND aceptada is not null", @usuario.id], :order => "created_at desc")
  end
  
  def myprofile
    @myprofile_active = ACTIVE
    @usuario = Usuario.find(current_usuario.id)
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
    @usuario = Usuario.find(current_usuario.id)
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
    sign_out
    redirect_to "/"
  end

end
