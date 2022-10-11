class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
    
    # todo change all this shit
    def hashify(val)
      Hash[val]
    end
    
    def get_hash_of_all_ratings(all_ratings)
      hashify(all_ratings.map {|rating| [rating, 1]})
    end

    def get_movies(m, sort_by_func)
      m.where(rating: @ratings_to_show.keys).order(sort_by_func)
    end
    
    def index
      @all_ratings = Movie.all_ratings
    
      @title_header = ''
      if params[:sort_by] == 'title'
        @title_header = 'hilite bg-warning'
      end
    
      @release_date_header = ''
      if params[:sort_by] == 'release_date'
        @release_date_header = 'hilite bg-warning'
      end
    
      if params.keys.include?(:ratings)
        @ratings_to_show = params[:ratings] 
      elsif session.keys.include?(:ratings)
        @ratings_to_show = session[:ratings]
      end
    
      if not params.keys.include?(:sort_by)
        sort_by = session[:sort_by]
      else
        sort_by = params[:sort_by] 
      end
    
      @ratings_to_show = get_hash_of_all_ratings(@all_ratings)
    
      ratings_match = (params[:ratings] == session[:ratings])
      sort_by_match = (params[:sort_by] == session[:sort_by])
    
      if not ratings_match or not sort_by_match
        session[:ratings] = @ratings_to_show
        session[:sort_by] = sort_by
      end
    
      @movies = get_movies(Movie, sort_by)
    
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