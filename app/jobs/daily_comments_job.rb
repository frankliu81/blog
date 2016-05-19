class DailyCommentsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later

    # for each user
    User.all.each do |user|
      puts "DailyComments.Job.perform"
      CommentsMailer.notify_post_owner_of_daily_comments(user).deliver_now
    end

  end
end
