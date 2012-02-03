class Usuarios::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @usuario = Usuario.find_for_facebook_oauth(request.env["omniauth.auth"], current_usuario)
    if @usuario.persisted?
      sign_in @usuario
      session["devise.at"] = request.env["omniauth.auth"]["credentials"]["token"]
      if @usuario.intereses.empty?
        redirect_to register_path
      else
        Usuario.sincroniza_con_facebook(@usuario, session["devise.at"])
        redirect_to home_path
      end
    else
      redirect_to "/"
    end
  end

end
