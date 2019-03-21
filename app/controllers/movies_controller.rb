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
    MovieInfoMailer.send_info(current_user, @movie).deliver_now
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
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
