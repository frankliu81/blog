class CommentsController < ApplicationController


  def create
    @post = Post.find params[:post_id]

    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new(comment_params)

    # important association
    @comment.post = @post

    if @comment.save
      #render text: "SUCCESS"
      redirect_to post_path(@post), notice: "Thanks for the comment"
    else
      #render text: "FAILURE"
      flash[:alert] = "Comment is not saved"
      render "posts/show"
    end
  end

  def destroy
    the_post = Post.find params[:post_id]
    comment = Comment.find params[:id]
    comment.destroy
    redirect_to post_path(the_post), notice: "Comment deleted"
  end

end
