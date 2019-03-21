require 'test_helper'

class CommentTest < ActiveSupport::TestCase
    def setup
        Rails.application.load_seed
    end
  
    test "creation failure without user" do
        c = Comment.new
        c.movie = Movie.first
        c.comment_content = "This is a simple comment"
        assert_not c.save
    end

    test "creation failure without movie" do
        u = User.create!(
            email: "example@example.com",
            password: "password"
        )
        
        c = Comment.new
        c.user = u
        c.comment_content = "This is a simple comment"
        assert_not c.save
    end

    test "can add comment" do 
        u = User.create!(
            email: "example@example.com",
            password: "password"
        )
        
        c = Comment.new
        c.user = u
        c.movie = Movie.first
        c.comment_content = "This is a simple comment"
        assert c.save
    end

    test "can not add second comment" do 
        u = User.create!(
            email: "example@example.com",
            password: "password"
        )
        
        c = Comment.new
        c.user = u
        c.movie = Movie.first
        c.comment_content = "This is a simple comment"
        c.save!

        c2 = Comment.new
        c2.user = u
        c2.movie = Movie.first
        c2.comment_content = "This is second simple comment"

        assert_not c2.save
    end

end