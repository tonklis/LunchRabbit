class OauthController < ApplicationController
  def new
    session[:at]=nil
    redirect_to authenticator.authorize_url(:scope => 'publish_stream,offline_access,email', :display => 'page')
  end

  def create
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code], authenticator)
    session[:at]=mogli_client.access_token
    user = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    session[:usuario] = Usuario.encuentra_o_crea(user.id)
    redirect_to "/"
  end

  def index
    redirect_to "/oauth/new" and return unless session[:at]
    user = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    session[:usuario] = Usuario.encuentra_o_crea(user.id)
  end

  def authenticator
    #@authenticator ||= Mogli::Authenticator.new('316932864999658', '25b7c93ff48f139e55984887babf1351', oauth_callback_url)
    @authenticator ||= Mogli::Authenticator.new('185077511587462', '3b2cc63f9dadfaae16ff3b10db7cd8e8', oauth_callback_url)
  end

end
