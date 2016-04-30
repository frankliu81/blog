namespace :blog do
  desc "Mail out the daily comments"
  task mail_daily_comments: :environment do
   puts "Mailing daily comments..."
   DailyCommentsJob.perform_now
 end
end
