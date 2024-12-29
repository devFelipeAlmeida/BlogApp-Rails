class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale_from_session

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
    redirect_back(fallback_location: root_path)
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  def set_locale_from_session
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
