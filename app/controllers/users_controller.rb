 class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    #puts params

    @user = User.find params[:id]
    # the page is passed in by application.html.erb
    # via <%= link_to "Edit Profile", edit_user_path(user_id: current_user.id, page: "password_reset") %>
    render "edit"

  end

  def create
    # we generate the password_digest automatically
    # has_secure_password make sure password == password_confirmation
    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    @user = User.new user_params

    if @user.save
      session[:user_id] = @user.id
      #redirect_to root_path, notice: "Account Created!"
      @user.generate_account_verification_data
      AccountVerifcationsMailer.send_verification_instructions(@user).deliver_later
      render "users/account_verifications/create"

    else
      render :new
    end

  end


  def update
    # puts params

    @user = User.find params[:id]

    user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)

    if @user.update user_params
      redirect_to root_path, notice: "Account Updated"
    else
      render :edit
    end

  end


  def destroy
    user = User.find_by_id params[:id]
    session[:user_id] = nil
    user.destroy
    redirect_to root_path, notice: "User deleted!"
  end

end
