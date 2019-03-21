require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
    def setup
        Rails.application.load_seed
    end

    test "can add a comment" do
        post "/users", params: {user: {email: "example@example.com", password: "password", password_confirmation: "password"}}
        assert_response :redirect
        follow_redirect!

        get "/movies/1"
        assert_response :success

        post "/comments", params: {comment: {comment_content: "This is a simple comment"}, movie_id: "1"}
    end

end