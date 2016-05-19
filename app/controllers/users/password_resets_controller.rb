class Users::PasswordResetsController < ApplicationController
  def new
  end

  def create

    #puts ">>>>>>>>>>>>>>>>>>> #{params.inspect}"

    if params[:email] == ""
      #puts ">>>>>>>>>>>>>>>>> email empty string"
      flash[:alert] = "Email should not be empty"
      render "new"
      return
    end

    user = User.find_by_email params[:email]
    if user
      user.generate_password_reset_data
      PasswordResetsMailer.send_instructions(user).deliver_later
    end
  end

  def edit
    @user = User.find_by_password_reset_token! params[:id]
  end

  def update

    @user = User.find_by_password_reset_token params[:id]

    if params[:user][:password] == ""
      flash[:alert] = "Password should not be empty"
      render "edit"
      return
    end

    user_params = params.require(:user).permit(:password, :password_confirmation)

    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password has expired, please try again"
    elsif @user.update user_params
      sign_in(@user)
      redirect_to root_path notice: "Password was reset successfully"
    else
      render :edit
    end

  end

end
