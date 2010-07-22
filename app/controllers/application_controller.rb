# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time

  helper_method :is_admin?
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  I18n.locale = 'es-ES'

  def is_admin?
    logged_in? && current_user.is_admin?
  end

  def admin_required
    is_admin? || admin_denied
  end

  def current_user_or_admin_required
    (current_user == @user || is_admin?) || current_user_denied
  end

  def current_user_denied
    flash[:notice] = t'general.current_user_denied'
    redirect_back_or_default('/')
  end

  def admin_denied
    flash[:notice] = t'general.admin_denied'
    redirect_back_or_default('/')
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
