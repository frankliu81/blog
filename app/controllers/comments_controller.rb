class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    comment_params = params.require(:comment).permit(:body, :post_id)
    @comment = Comment.new(comment_params)

    if @comment.save
      #render text: "SUCCESS"
      redirect_to comment_path(@comment)
    else
      #render text: "FAILURE"
      render :new
    end
  end

  def show
    @comment = Comment.find params[:id]
  end

  def index
    @comments = Comment.all
  end

  def edit
    @comment = Comment.find params[:id]
  end

  def update
    @comment = Comment.find params[:id]
    comment_params = params.require(:comment).permit([:body, :post_id])

    if @comment.update comment_params
      redirect_to comment_path(@comment)
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy
    redirect_to comments_path
  end

end
