class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_post, only: [:edit, :update, :destroy]


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
    @posts = Post.order('created_at DESC').page(params[:page]).per(7)
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

  def favorites
  end

  def search
    #@requests = Request.all
    @posts = Post.search(params[:search]).page(params[:page]).per(7)
    # render the index page
    render :index
  end


private
  def find_post
    @post = Post.find params[:id]
  end

  def post_params
    post_params = params.require(:post).permit([:title, :body, :category_id],
    {tag_ids: []} )

    # implementation for when we were passing in tag_values
    #post_params = params.require(:post).permit([:title, :body, :category_id],
    #{tag_values: []} )
    # typically, with tags made with collection_check_boxes, there is a hidden field
    # which field enables the scenario where we have no updates,
    # but don't want to clear existing tags
    # since we are mapping the tag values to ids, we will insert the "" value to
    # id after the mapping
    # tag_ids = Tag.where("name in (?)", params["tag_values"]).pluck("id")
    # tag_ids.push("")

    # byebug
  end

  def authorize_post
    redirect_to root_path, notice: "Unauthorized access" unless can? :crud, @post
  end



end
