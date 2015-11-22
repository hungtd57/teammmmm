class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    include SessionsHelper
    skip_before_action :verify_authenticity_token
    def logged_in_user
    unless logged_in?
      flash[:danger] = "you must be login to doing this action"
      redirect_to login_url
    end
  end

end
