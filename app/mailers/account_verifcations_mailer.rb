class AccountVerifcationsMailer < ApplicationMailer
    def send_verification_instructions(user)
      @user = user
      #puts ">>>>>>>>>>>>>>>>>> send_verificaiton_instructions#{@user.email}"
      mail(to: @user.email, subject: "Account Verification Instructions")
    end
end
