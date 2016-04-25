require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
    
    it "assigns the user instance variable" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "#create" do
    context "with valid user attribute" do
      def valid_request
        post :create, user: FactoryGirl.attributes_for(:user)
      end

      it "creates a record in the database" do
          count_before = User.count
          valid_request
          count_after = User.count
          expect(count_after).to eq(count_before + 1)
      end

      # monkey-patched test mailer to call deliver_now
      # in spec/support/message_delivery.rb
      it "sends an account verification e-mail" do
        expect { valid_request }.to change{ActionMailer::Base.deliveries.count}.by(1)
      end

      it "renders the account verificaitons create page" do
        valid_request
        expect(response).to render_template("users/account_verifications/create")
      end

      it "sets the session user_id with the created user" do
        valid_request
        expect(session[:user_id]).to eq(User.last.id)
      end
    end

    context "with invalid user attribute" do
      def invalid_request
        post :create, user: FactoryGirl.attributes_for(:user).merge({first_name: nil})
      end

      it "doesn't add a record to the database" do
        count_before = User.count
        invalid_request
        count_after = User.count
        expect(count_after).to eq(count_before)
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end
    end

  end
end
