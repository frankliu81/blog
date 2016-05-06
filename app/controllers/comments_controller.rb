class CommentsController < ApplicationController
  before_action :find_comment, only: [:show, :edit, :update_successdate, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_comment, only: [:edit, :update, :destroy]

  def create

    @post = Post.find params[:post_id]

    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new(comment_params)

    # important association
    @comment.post = @post
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        #render text: "SUCCESS"
        #CommentsMailer.notify_post_owner(Comment.last).deliver_later
        format.html { redirect_to post_path(@post), notice: "Thanks for the comment"}
        format.js { render :create_success }
      else
        #render text: "FAILURE"
        flash[:alert] = "Comment is not saved"
        format.html { render "posts/show" }
        format.js { render :create_failure}
      end
    end

  end

  def edit
    @post = Post.find params[:post_id]
    @comment = Comment.find params[:id]
  end

  def update
    @post = Post.find params[:post_id]
    @comment = Comment.find params[:id]
    comment_params = params.require(:comment).permit(:body)

    respond_to do |format|
      if @comment.update comment_params
        format.html { redirect_to post_path(@post), notice: "Comment updated"}
        format.js { render :update_success}
      else
        format.html { render :edit }
        format.js { render :update_failure}
      end
    end

  end

  def destroy
    @post = Post.find params[:post_id]
    @comment = Comment.find params[:id]
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_path(the_post), notice: "Comment deleted" }
      format.js { render }
    end
  end

private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def authorize_comment
    redirect_to root_path unless can? :crud, @comment
  end

end
