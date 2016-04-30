class CommentsController < ApplicationController
  before_action :find_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_comment, only: [:edit, :update, :destroy]

  def create

    @post = Post.find params[:post_id]

    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new(comment_params)

    # important association
    @comment.post = @post
    @comment.user = current_user

    if @comment.save
      #render text: "SUCCESS"
      #CommentsMailer.notify_post_owner(Comment.last).deliver_later
      redirect_to post_path(@post), notice: "Thanks for the comment"
    else
      #render text: "FAILURE"
      flash[:alert] = "Comment is not saved"
      render "posts/show"
    end
  end

  def destroy
    the_post = Post.find params[:post_id]
    @comment = Comment.find params[:id]
    @comment.destroy
    redirect_to post_path(the_post), notice: "Comment deleted"
  end

private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def authorize_comment
    redirect_to root_path unless can? :crud, @comment
  end

end
