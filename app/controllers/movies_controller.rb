class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if !session.has_key?(:sort) && !session.has_key?(:ratings)
      session[:ratings] = @all_ratings.map{ |element| [element, '1'] }.to_h
    end
    if !params.has_key?(:sort) && !params.has_key?(:ratings)
      if params.has_key?(:commit)
        redirect_to movies_path(:sort => '', :ratings => {}) and return
      end
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings]) and return
    else
      ratings = params[:ratings]
      sort = params[:sort]
      session[:sort] = sort
      session[:ratings] = ratings
    end
    if ratings.nil?
      @ratings_to_show = []
    else
      @ratings_to_show = ratings.keys
    end
    @ratings_to_show_hash = @ratings_to_show.map{ |element| [element, '1'] }.to_h
    @movies = Movie.with_ratings(@ratings_to_show, sort)
    if sort == 'title'
      @title_css = 'hilite bg-warning'
    elsif sort == 'release_date'
      @release_date_css = 'hilite bg-warning'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
