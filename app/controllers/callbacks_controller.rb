class CallbacksController < ApplicationController
  def google
    # test printing out @auth in google.html.erb to verify we have
    # a response after sign in
    #@auth = request.env['omniauth.auth']['credentials']

    omniauth_data = request.env['omniauth.auth']
    user = User.where(provider: "google", uid: omniauth_data["uid"]).first
    if user      
      sign_in(user)
      redirect_to root_path, flash: {success: "Signed In" }
    else
      user = User.create_from_google(omniauth_data)
      # byebug
      sign_in(user)
      redirect_to root_path, flash:{ success: "Signed In" }
      # render json: omniauth_data
    end

  end

end
