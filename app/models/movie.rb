class Movie < ActiveRecord::Base

  def self.all_ratings
    return ['G','PG','PG-13','R']
    # g 
  end

  def self.with_ratings(ratings_list)

    if ratings_list.length() == 0
      return Movie.all
    end 

    updated_ratings = ratings_list.map { |a| a.upcase }
    Movie.where(rating: updated_ratings)
  end

  

end