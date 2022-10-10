class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end

    def get_ratings_selected(ratings_to_show)
      output = {}
      for key in ratings_to_show
        output[key] = ratings_to_show[key] || '1'
      end
      return output
    end
    
    # todo change all this shit
    def index
      @movies = Movie.all
      @all_ratings = Movie.all_ratings
      @title_header = ''
      @release_date_header = ''
    
      @ratings_to_show = []
      ratings_to_check = params.keys
      if ratings_to_check.includes?(:ratings)
        @ratings_to_show = params[:ratings].keys
        @ratings_selected = get_ratings_selected(@ratings_to_show) # changed this from @ratings_to_show_hash 
      end
    
      @movies = Movie.with_ratings(@ratings_to_show)
    
      sort_by_action = params[:sort_by]
      if !sort_by_action.nil?
        @movies = @movies.order(sort_by_action)
        if params[:sort_by] == "title"
          @title_header = 'hilite bg-warning'
        elsif
          @release_date_header = 'hilite bg-warning' 
        end
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