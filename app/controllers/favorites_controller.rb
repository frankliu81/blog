class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    favorite = Favorite.new
    # associate the user and post with the favorites
    favorite.user = current_user
    # post is defined as a method below, found via a find of post_id
    favorite.post = post

    if favorite.save
      redirect_to post_path(post), notice: "Favorited!"
    else
      redirect_to post_path(post), notice: "You have already favorited!"
    end

  end

  def destroy
    favorite.destroy
    redirect_to post_path(favorite.post_id), notice: "Unfavorited!"
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
