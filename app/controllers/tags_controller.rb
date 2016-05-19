class TagsController < ApplicationController
  def index
    #byebug
    @tags = Tag.all
    respond_to do |format|
      format.json { render json: @tags}
    end
  end
end
