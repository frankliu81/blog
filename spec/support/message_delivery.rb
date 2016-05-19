require 'action_mailer'
#Monkey patch #deliver_later in the test environment to send the email immediately.
# spec/support/message_delivery.rb
class ActionMailer::MessageDelivery
  def deliver_later
    deliver_now
  end
end
