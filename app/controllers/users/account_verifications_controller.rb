class Users::AccountVerificationsController < ApplicationController
  def new
    # when the user signs in via sessions#create, and the account hasn't been activated
    # we will call account_verifications#new with the user_id, and we can use this
    # to look up the user email for sending account activation details
    # in new.html.erb
    #puts ">>>>>>>>>>>>>>>>> account_verification#new: params #{params.inspect}"
    #@user = User.find params[:user_id]
    @user = current_user
  end

  def create
    user = User.find_by_email params[:user][:email]
    #puts ">>>>>>>>>>>>>>>> account_verifications#create #{params.inspect}"
    if user
      user.generate_account_verification_data
      AccountVerifcationsMailer.send_verification_instructions(user).deliver_later
    end
  end

  def edit
    @user = User.find_by_account_verification_token params[:id]
    # method in the user model, that does activate
    if @user.update(activated: true)
      sign_in(@user)
      redirect_to root_path, notice: "Account was activated successfully"
    else
      flash[:notice] = "Account activation failed, please try again or contact support"
      render :edit
    end

  end

end
