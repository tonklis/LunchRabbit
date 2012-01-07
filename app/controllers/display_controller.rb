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
    intereses = @client.likes
    @zona = @usuario.zonas.first
    @intereses = []
    
    intereses.each do |interes|
      if ["Tv show", "Musician/band", "Movie", "Book", "Interest"].index(interes.category)
        @intereses << Interes.find_or_create_by_facebook_id(interes.id){|u|
          u.nombre = interes.name
          u.categoria = interes.category}
      end 
    end
    

  end

  def home
    redirect_to "/" and return if session[:at].nil?
    @home_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    @recomendados = Usuario.busqueda(@usuario.facebook_id, params[:limit])
  end
  
  def myprofile
    redirect_to "/" and return if session[:at].nil?
    @myprofile_active = ACTIVE
    @usuario = Usuario.find(session[:usuario_id])
    intereses = @usuario.intereses
    @intereses_music = intereses.find_all{|interes| interes.categoria == 'Musician/band'}
    @intereses_movies = intereses.find_all{|interes| interes.categoria == 'Movie'}
    @intereses_tv = intereses.find_all{|interes| interes.categoria == 'Tv show'}
    @intereses_books = intereses.find_all{|interes| interes.categoria == 'Book'}
    @intereses_other = intereses.find_all{|interes| interes.categoria == 'Interest'}
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
    @intereses_other = intereses.find_all{|interes| interes.categoria == 'Interest'}
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
