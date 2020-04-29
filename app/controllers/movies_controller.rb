class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    #ratings
    @all_ratings = Movie.all.distinct.pluck(:rating)
    if params[:ratings]
      session[:ratings] = params[:ratings]
    else
      params[:ratings] = session[:ratings]
    end
    @ratings = params[:ratings]

    @ratings.keys.each do |rating|
      params[rating] = true
    end
    @current_ratings = params[:ratings] 

    #sort
    if !params[:sort]
      params[:sort] = session[:sort]
    else
      session[:sort] = params[:sort]
    end
    
    #@movies
    if params[:ratings].present? && params[:sort].present?
      @movies = Movie.where(rating: @current_ratings.keys).order(params[:sort]);
    elsif params[:ratings].present?
      @movies = Movie.where(rating: @current_ratings.keys);
    else
      @movies = Movie.order(params[:sort])
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

end
