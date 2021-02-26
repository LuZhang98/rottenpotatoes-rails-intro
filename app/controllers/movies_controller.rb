class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []

    if params[:ratings] == nil
      if session[:ratings] == nil
        @ratings_to_show = Hash[@all_ratings.map {|rating| [rating, rating]}]
      elsif params[:sort] != session[:sort]
        @ratings_to_show = session[:ratings]
      else
        @ratings_to_show = Hash[@all_ratings.map {|rating| [rating, rating]}]
      end

    elsif params[:ratings]
      @ratings_to_show = params[:ratings]
      
    else
      @ratings_to_show = session[:ratings]
    end

    if params[:ratings] != session[:ratings]
      session[:ratings] = @checked_ratings
    end


    if params[:sort] == nil && session[:sort] == nil
      @sort == nil
    elsif params[:sort]
      @sort = params[:sort]
    else
      @sort = session[:sort]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = @sort
    end

    if @sort == 'title'
      @title_header = {:title => :asc} 
      @title_header = 'hilite'
      @title_header = "bg-warning"
    end
    if @sort == 'release_date'
      @date_header = {:release_date => :asc}
      @date_header = 'hilite'
      @date_header = "bg-warning"
    end

    
    @movies = Movie.where(rating: @ratings_to_show.keys).order(@sort)
    
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
