class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    #puts params

    @user = User.find_by_id params[:id]
    # the page is passed in by application.html.erb
    # via <%= link_to "Edit Profile", edit_user_path(user_id: current_user.id, page: "password_reset") %>
    if params[:page] == "edit_password"
      render "edit_password"
    elsif params[:page] == "edit"
      render "edit"
    end

  end

  def update
    # puts params

    @user = User.find_by_id params[:id]

    # password reset scenario
    if params[:user][:old_password] && params[:user][:password] && params[:user][:password_confirmation]
      # authenticate against the old password first
      if !@user.authenticate params[:user][:old_password]
        flash[:notice] = "Need to enter the correct old password"
        render "edit_password"
        return
      end

      if params[:user][:old_password] == params[:user][:password]
        flash[:notice] = "Password should be different than old password"
        render "edit_password"
        return
      end
    end

    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)

    if @user.update user_params
      redirect_to root_path, notice: "Account Updated"
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
