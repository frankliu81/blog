class CommentsMailer < ApplicationMailer
  def notify_post_owner(comment)
    @comment = comment
    @user = comment.user
    @post = comment.post
    @owner = @post.user
    return unless @owner
    mail(to: @owner.email, subject: "you got a comment!")
  end
end
