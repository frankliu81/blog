class PostsController < ApplicationController

  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_question, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]


  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    # important association
    @post.user = current_user

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

    # puts params
    # puts params[:id]
    # puts params[:post][:title]

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
    post_params = params.require(:post).permit([:title, :body, :category_id])
  end

  def authorize_question
    redirect_to root_path unless can? :crud, @post
  end

end
