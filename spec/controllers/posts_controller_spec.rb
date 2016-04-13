require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "#new" do
    before {get :new}

    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "assigns a post object" do
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "#create" do
    describe "with valid attributes" do

      def valid_request
        post :create, post: {title: "sample title", body: "sample body"}
      end

      it "saves a record to the database" do
        count_before = Post.count
        valid_request
        count_after = Post.count
        expect(count_after).to eq(count_before + 1)
      end

      it "redirects to the post's show page" do
        valid_request
        expect(response).to redirect_to(post_path(Post.last))
      end

      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end


    describe "with invalid attributes" do

      def invalid_request
        # no title
        post :create, post: {body: "sample body"}
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "sets an alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end

      it "doesn't save a record to the database" do
        count_before = Post.count
        invalid_request
        count_after = Post.count
        expect(count_after).to eq(count_before)
      end

    end

  end

end
