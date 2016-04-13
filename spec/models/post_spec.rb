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

    describe "body_snippet" do

      it "returns max 100 characters with ... for a total of 103 characters" do
        p = Post.new title: "12345678", body: "0" * 101
        body_snippet = p.body_snippet
        expect(body_snippet.length).to eq(103)
        expect(body_snippet[-3..-1]).to eq("...")
      end

    end

end
