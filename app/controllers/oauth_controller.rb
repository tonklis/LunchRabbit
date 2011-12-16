class OauthController < ApplicationController
  def new
    session[:at]=nil
    redirect_to authenticator.authorize_url(:scope => 'publish_stream,offline_access,email', :display => 'page')
  end

  def create
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code], authenticator)
    session[:at]=mogli_client.access_token
    redirect_to "/display/index"
  end

  def index
    redirect_to "/display/index" and return unless session[:at]
    user = Mogli::User.find("me", Mogli::Client.new(session[:at]))
    @user = user
    @posts = user.posts
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new('316932864999658', '25b7c93ff48f139e55984887babf1351', oauth_callback_url)
  end

  def show
    redirect_to "/display/index" and return unless session[:at]
    @user = Mogli::User.find("me", Mogli::Client.new(session[:at]))

    respond_to do |format|
      format.html # show.html.erb
    end

  end

end
