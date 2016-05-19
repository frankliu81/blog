class CommentsMailer < ApplicationMailer
  def notify_post_owner(comment)
    @comment = comment
    @user = comment.user
    @post = comment.post
    @owner = @post.user
    return unless @owner
    mail(to: @owner.email, subject: "you got a comment!")
  end

  def notify_post_owner_of_daily_comments(owner)

    # find all the posts
    #puts "===#{user.full_name}==="
    @owner = owner
    @notification_period = 24.hours

    puts ">>>> notify_post_owner_of_daily_comments"

    if @owner.posts.empty?
      return
    end

    puts ">>>> user.posts not empty"

    @daily_comments = Comment.where("post_id in (?) and created_at > ? and created_at < ?", @owner.posts.ids, DateTime.now - @notification_period, DateTime.now)

    if @daily_comments.empty?
      return
    end

  puts ">>>> daily_comments not empty"


    mail(to: @owner.email, subject: "Your daily comments!")

  end

  def comments_by_post(post)
    @daily_comments.where("post_id = ?", post.id)
  end
  helper_method :comments_by_post

end
