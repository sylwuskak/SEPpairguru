require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
    def setup
        Rails.application.load_seed
    end

    test "can reach movies page" do
        get "/movies" 
        assert_response :success
    end

    test "can reach movie page" do
        get "/movies/1" 
        assert_response :success
    end

end