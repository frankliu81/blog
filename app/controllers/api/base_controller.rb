class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  # before_action :authenticate_api_key

private
  def authenticate_api_key
    @user = User.find_by(api_key: params[:api_key])
    head :unauthorized unless @user
  end

end
