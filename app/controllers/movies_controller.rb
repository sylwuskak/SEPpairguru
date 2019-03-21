class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]
  require 'net/http'
  require 'json'


  def index
    @movies = Movie.all.decorate
    @movies_titles = @movies.map{|m| m.title}.uniq
    @movies_data = @movies_titles.map do |title|
      [title, movie_data(title.gsub(' ', ''))]
    end.to_h

    
    respond_to do |format|
      movies_json = @movies.map do |movie|
        {
          id: movie.id,
          title: movie.title
        }
      end.to_json

      format.html
      format.json do
        render json: movies_json
      end
    end
  end

  def show
    @movie = Movie.find(params[:id])
    @movie_data = movie_data(@movie.title.gsub(' ', ''))

    
    respond_to do |format|
      format.html
      format.json do
        render json: {
          id: @movie.id,
          title: @movie.title
        }.to_json
      end
    end
  end

  def send_info
    @movie = Movie.find(params[:id])
    Thread.new do 
      MovieInfoMailer.send_info(current_user, @movie).deliver_now
    end
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    Thread.new do 
      MovieExporter.new.call(current_user, file_path)
    end
    redirect_to root_path, notice: "Movies exported"
  end

  def user_statistics
    Rails.cache.fetch("#{Time.now}/competing_price", expires_in: 12.hours) do
      comments = Comment.includes(:user).where("created_at > ?", Time.now-7.days) 
      @users = comments.group_by{|c| c.user}.sort_by{|k, v| -v.length}.map{|k, v| [k, v.length]}[0..9]
    end
  end

  private
  def movie_data(title)
    url = "https://pairguru-api.herokuapp.com/api/v1/movies/" + title
    uri = URI(url)
    response = Net::HTTP.get(uri)

    @movie_data = JSON.parse(response).try(:[], "data").try(:[], "attributes")
    if @movie_data 
      @movie_data["poster_image"] = "https://pairguru-api.herokuapp.com" + @movie_data["poster"]
    end
    @movie_data
  end
end
