class Users::PasswordChangesController < ApplicationController
  def edit
    #puts params
    @user = User.find_by_id params[:id]
  end

  def update
    # puts params

    @user = User.find_by_id params[:id]


  # password change scenario
    # if params[:user][:old_password] && params[:user][:password] && params[:user][:password_confirmation]
    #   # authenticate against the old password first
    #   if !@user.authenticate params[:user][:old_password]
    #     flash[:alert] = "Need to enter the correct old password"
    #     render "edit"
    #     return
    #   end
    #
    #   if params[:user][:old_password] == params[:user][:password]
    #     flash[:alert] = "Password should be different than old password"
    #     render "edit"
    #     return
    #   end
    #
    #   if params[:user][:password] == ""
    #     flash[:alert] = "Password should not be empty"
    #     render "edit"
    #     return
    #   end
    #
    # end

    # user_params = params.require(:user).permit(:password, :password_confirmation)

    # if @user.update user_params
    #   redirect_to root_path, notice: "Password Updated"
    # else
    #   render :edit
    # end

    if @user.attempt_password_change(password_params[:old_password], password_params[:password])
      redirect_to root_path, notice: "Password successfully changed!"
    else
      render :edit
    end

  end

  private
    def password_params
      params.require(:user).permit(:old_password, :password)
    end
end
