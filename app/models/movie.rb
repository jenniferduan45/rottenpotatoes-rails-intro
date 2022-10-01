class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list, sort)
    if ratings_list.length == 0
      return Movie.all.order(sort)
    else
      return Movie.where(rating: ratings_list).order(sort)
    end
  end
end
