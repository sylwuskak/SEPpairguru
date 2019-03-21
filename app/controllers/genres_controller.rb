class GenresController < ApplicationController
  def index
    @genres = Genre.all.decorate

    respond_to do |format|
      genres_json = @genres.map do |genre|
        {
          id: genre.id,
          name: genre.name,
          number_of_movies: genre.number_of_movies
        }
      end.to_json

      format.html
      format.json do
        render json: genres_json
      end
    end

  end

  def movies
    @genre = Genre.find(params[:id]).decorate
    @movies_titles = @genre.movies.map{|m| m.title}.uniq
    @movies_data = @movies_titles.map do |title|
      [title, movie_data(title.gsub(' ', ''))]
    end.to_h
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
