class Movie < ActiveRecord::Base
        
    def self.all_ratings
        return %w(G PG PG-13 R)
    end
    
end
