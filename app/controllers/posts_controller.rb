class PostsController < ApplicationController

  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      #render text: "SUCCESS"
      redirect_to post_path(@post), notice: "Post created"
    else
      #render text: "FAILURE"
      flash[:alert] = "Post not created"
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def index
    @posts = Post.all
  end

  def edit
  end

  def update

    if @post.update post_params
      redirect_to post_path(@post), notice: "Post updated"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted"
  end

private
  def find_post
    @post = Post.find params[:id]
  end

  def post_params
    post_params = params.require(:post).permit([:title, :body])
  end

end
