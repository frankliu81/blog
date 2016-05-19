class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user!
    if user_signed_in?
      # don't need to pass in the user_id, it will be available in
      redirect_to new_account_verification_path, notice: "Please Activate Your Account!" unless current_user.activated?
    else
      redirect_to new_session_path, notice: "Please sign in!"
    end
  end

  def user_signed_in?
    session[:user_id].present?
  end
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.find session[:user_id] if user_signed_in?
  end
  helper_method :current_user

  def sign_in(user)
    session[:user_id] = user.id
  end

end
