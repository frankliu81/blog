require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  # define a class variable @the_post if it has not been defined
  # via memoization
  # :post is referring to the name in the factory
  let(:the_post) { FactoryGirl.create(:post_with_body)}
  let(:user) { FactoryGirl.create(:user)}


  describe "#new" do

    context "without a signed in user" do
      before {get :new}

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_session_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end

    end

    context "with a signed in user" do
      before {
        @controller.sign_in(user)
        get :new
      }


      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "assigns a post object" do
        expect(assigns(:post)).to be_a_new(Post)
      end

    end


  end

  describe "#create" do

    context "without a signed in user" do
      before {valid_request}
      def valid_request
        #post :create, post: {title: "sample title", body: "sample body"}
        post :create, post: FactoryGirl.attributes_for(:post_with_body)
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_session_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end

    end

    context "with a signed in user" do
      before { @controller.sign_in(user) }

      describe "with valid attributes" do

        def valid_request
          #post :create, post: {title: "sample title", body: "sample body"}
          post :create, post: FactoryGirl.attributes_for(:post_with_body)
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

  # show has no authentication enforced
  describe "#show" do

    before do
      # :show is the name of the method in the controller
      get :show, id: the_post.id
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "assigns the instance variable named post" do
      expect(assigns(:post)).to eq(the_post)
    end

  end

  # index has no authentication enforced
  describe "#index" do

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns the posts instance variable with all posts in the DB" do
      p1 = FactoryGirl.create(:post_with_body)
      p2 = FactoryGirl.create(:post_with_body)
      get :index
      # @posts = Post.all would return ActiveRecord::Relation which acts like an
      # array
      expect(assigns(:posts)).to eq([p1, p2])
    end


  end

  describe "#edit" do

    context "without a signed in user" do
      before { get :edit, id: the_post.id}

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_session_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end

    end

    context "with a signed in user that is different as the post owner" do
      before do
        # here we try to access the post via another user
        # this generated user used for sign_in would be different from the_post.user
        # which is generated to a different user via association in the
        # post factory
        @controller.sign_in(user)
        get :edit, id: the_post.id
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "with a signed in user that is the same as the post owner" do
      before do
        @controller.sign_in(the_post.user)
      end

      it "renders the edit template" do
        get :edit, id: the_post.id
        expect(response).to render_template(:edit)
      end

      it "assigns an instance variable post with the passed id " do
        get :edit, id: the_post.id
        expect(assigns(:post)).to eq(the_post)
      end
    end


  end

  describe "#update" do


    context "without a signed in user" do
      let(:new_valid_body) { Faker::Hacker.say_something_smart}

      before do
        patch :update, id: the_post.id, post: {body: new_valid_body}
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_session_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end

    end

    context "with a signed in user that is different as the post owner" do
      let(:new_valid_body) { Faker::Hacker.say_something_smart}
      before do
        # here we try to access the post via another user
        # this generated user used for sign_in would be different from the_post.user
        # which is generated to a different user via association in the
        # post factory
        @controller.sign_in(user)
        patch :update, id: the_post.id, post: {body: new_valid_body}
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "with a signed in user that is the same as the post owner" do
      before do
        @controller.sign_in(the_post.user)
      end

      describe "with valid parameters" do

        let(:new_valid_body) { Faker::Hacker.say_something_smart}

        before do
          patch :update, id: the_post.id, post: {body: new_valid_body}
        end

        it "updates the record whose id is passed" do
          expect(the_post.reload.body).to eq(new_valid_body)
        end

        it "redirects to the show page" do
          # we need to go to the show page with a specific post_path
          # ie. show/:id
          expect(response).to redirect_to(post_path(the_post))
        end

        it "sets a flash notice message" do
          expect(flash[:notice]).to be
        end
      end


      describe "with invalid parameters" do
        before do
          patch :update, id: the_post.id, post: {title: ""}
        end

        it "does not update the record whose id is passed" do
          # ie. the_post title stays the same as the reloaded version
          expect(the_post.title).to eq(the_post.reload.title)
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

      end

    end

  end

  describe "#destroy" do


    context "without a signed in user" do
      before do
        the_post # give Post a count
        delete :destroy, id: the_post.id
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_session_path)
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end
    end

    context "with a signed in user that is different as the post owner" do
      before do
        # here we try to access the post via another user
        # this generated user used for sign_in would be different from the_post.user
        # which is generated to a different user via association in the
        # post factory
        @controller.sign_in(user)
        the_post # give Post a count
        delete :destroy, id: the_post.id
      end

      it "redirects to the root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "with a signed in user that is the same as the post owner" do
      before do
        @controller.sign_in(the_post.user)
      end


      it "removes the post from the database" do

        the_post # give Post a count
        expect {delete :destroy, id: the_post.id}.to change{ Post.count }.by(-1)

        # long way alternative
        # count_before = Post.count
        # delete :destroy, id: the_post.id
        # count_after = Post.count
        # expect(count_after).to eq(count_before - 1)
      end

      it "redirets to the index page" do
        delete :destroy, id: the_post.id
        expect(response).to redirect_to(posts_path)
      end

      it "sets a flash message" do
        delete :destroy, id: the_post.id
        expect(flash[:notice]).to be
      end
    end
  end


end
