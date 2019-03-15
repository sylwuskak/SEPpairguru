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

      format.json do
        render json: genres_json
      end
    end

  end

  def movies
    @genre = Genre.find(params[:id]).decorate
  end
end
