class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = User.find_by_id params[:id]
  end

  def update
    @user = User.find_by_id params[:id]
    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)

    if @user.update user_params
      redirect_to root_path notice: "Account Updated"
    else
      render :edit
    end

  end

  def create
    # we generate the password_digest automatically
    # has_secure_password make sure password == password_confirmation
    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    @user = User.new user_params

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account Created!"
    else
      render :new
    end

  end

  def destroy
    user = User.find_by_id params[:id]
    session[:user_id] = nil
    user.destroy
    redirect_to root_path, notice: "User deleted!"
  end

end
