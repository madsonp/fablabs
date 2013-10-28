class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_login
    if current_user.nil?
      redirect_to signin_url(goto: request.path), flash: { error: "You must first sign in to access this page" }
    end
  end

  before_action :set_locale

private

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
    # current_user.locale
    # request.subdomain
    # request.env["HTTP_ACCEPT_LANGUAGE"]
    # request.remote_ip
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  helper_method :current_or_null_user
  def current_or_null_user
    if current_user == nil
      User.new
    else
      current_user
    end
  end

  helper_method :current_user
  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      # Log out user if their id don't exist
      session[:user_id] = nil
    end
  end

end
