class Api::V1::PostsController < Api::BaseController

  def index
    # 1 is the default page if no page is defined
    page_num = Integer(params.fetch(:page, "1"))
    entries_per_page = 7;
    page_offset = (page_num - 1) * entries_per_page
    @posts = Post.order("created_at DESC").offset(page_offset).limit(entries_per_page);
    render json: @posts
  end

  def show
    @post = Post.find(params[:id])
    render json: @post
  end

  def create
    post_params = params.require(:post).permit(:title, :body, :user_id, :category_id)
    #post.user = @user
    post = Post.new(post_params)

    if post.save
      head :ok
    else
      render json: { errors: post.errors.full_messages }
    end
  end

end
