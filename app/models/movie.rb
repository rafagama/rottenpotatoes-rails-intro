class Movie < ActiveRecord::Base
    @ratings = ['G','PG','PG-13','NC-17','R']

    def self.ratings
        return @ratings
    end
    
    def self.all_checked
        @checked = Hash.new
        @ratings.each do |rating|
            @checked[rating] = true
        end
        return @checked
    end

    def self.get_checked(keys)
        @ratings.each do |rating|
            if keys.include?(rating)
                @checked[rating] = true
            else
                @checked[rating] = false
            end
        end
        return @checked
    end

end
