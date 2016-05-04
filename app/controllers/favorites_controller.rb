class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :post, only: [:create, :destroy]
                          # this will call the question method to force
                          # finding a post as we will need it for both
                          # the create and destroy actions when we render
                          # the _favorite.html.erb partial and the post_favorite
                          # in posts_helper.rb tries to access @post

  def create
    favorite = Favorite.new
    # associate the user and post with the favorites
    favorite.user = current_user
    # post is defined as a method below, found via a find of post_id
    favorite.post = post

    respond_to do |format|
      if favorite.save
        format.html { redirect_to post_path(post), notice: "Favorited!" }
        format.js { render } # favorites/create.js.erb
      else
        format.html { redirect_to post_path(post), notice: "You have already favorited!" }
        format.js { render js: "alert('Can\'t favorite, please refresh the page!')"; }
      end
    end

  end

  def destroy
    favorite.destroy
    respond_to do |format|
      format.html { redirect_to post_path(favorite.post_id), notice: "Unfavorited!" }
      format.js { render }
    end
  end

  def index
  end

private

    def post
      @post ||= Post.find params[:post_id]
    end

    def favorite
      @favorite ||= Favorite.find params[:id]
    end
end
