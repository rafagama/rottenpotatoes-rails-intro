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
    @all_ratings = Movie.ratings
    @movies = Movie.all
    
    if @checked == nil
      @checked = Movie.init_checked
    end

    update_session
    check_params
  
    # if there is a rating key, then filter movies
    if params.has_key?(:ratings)
      filter_movies
    end

    # if there is a sort_by key, then sort movies
    #if session.has_key?(:sort_by)
    #  sort_movies(session[:sort_by])
    #end
  end
  
  
  def update_session
    # Overwrite old session with new param rating or get session param
    if params.has_key?(:ratings) 
      session[:ratings] = params[:ratings]
    end
    # Overwrite old session with new param sort_by or get session param
    if params.has_key?(:sort_by) 
      session[:sort_by] = params[:sort_by]
    end
  end
  
  def check_params
    if (session.has_key?(:ratings) ^ params.has_key?(:ratings)) ||
          (session.has_key?(:sort_by) ^ params.has_key?(:sort_by))
      parameters = Hash.new
      parameters[:ratings] = session[:ratings]
      parameters[:sort_by] = session[:sort_by]

      # forces flash to keep message
      flash.keep
    
      # redirect with the proper params, to keep RESTfulness
      redirect_to movies_path(parameters)
    end
  end
  
  def filter_movies
    @checked = Movie.update_checked(params[:ratings]) 
    keys = params[:ratings].keys
    @movies = Movie.where(rating: keys)
  end
  
#  def sort_movies(type)
#    if type == "title"
#      @movies = @movies.sort {|a, b| a.title <=> b.tite}
#      @hilite_title = "hilite"
#    elsif type == == "release_date"
#      @movies = @movies.sort {|a, b| a.release_date <=> b.release_date}.reverse
#      @hilite_release_date = "hilite"
#    end
#  end

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
