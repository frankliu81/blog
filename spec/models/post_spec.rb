require 'rails_helper'

RSpec.describe Post, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "validations" do

      it "requires a title" do
        # GIVEN
        p = Post.new

        # WHEN
        validation_outcome = p.valid?

        # THEN
        expect(validation_outcome).to eq(false)
      end

      it "requires a post title with 7 characters" do
        # GIVEN
        # if you don't have initialize, you need to assign an attribute with a hash
        p = Post.new title: "d", body: "sample body"

        # WHEN
        validation_outcome = p.valid?

        # THEN
        #
        expect(p.errors[:title]).to include("Title needs to be at least 7 characters long.")
      end

      it "accept a post title with 7 characters" do
        # GIVEN
        p = Post.new title: "12345678", body: "sample body"

        # WHEN
        validation_outcome = p.valid?

        # THEN
        expect(validation_outcome).to eq(true)
      end

      it "requires a body" do
        # GIVEN
        p = Post.new title: "12345678"

        # WHEN
        validation_outcome = p.valid?

        #puts p.errors.inspect

        # THEN
        expect(p.errors).to have_key :body
      end
    end

    # . a method that we are testing
    # good idea to have two tests

    describe ".body_snippet" do

      # it "returns max 100 characters with ... for a total of 103 characters" do
      #   p = Post.new title: "12345678", body: "0" * 101
      #   body_snippet = p.body_snippet
      #   expect(body_snippet.length).to eq(103)
      #   expect(body_snippet[-3..-1]).to eq("...")
      # end

      # we technically don't need to connect to database
      it "returns 100 characters with ... if it's more than a 100 characters" do
        p = Post.new body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et"
        expect(p.body_snippet.to eq("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore..."))
      end


      it "returns the body if it's 100 characters or less" do
        p = Post.new body: "hello world"
        expect(p.body_snippet.to eq("hello world"))
      end

    end

  

end
