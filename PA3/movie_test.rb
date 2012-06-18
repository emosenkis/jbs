# Eitan Mosenkis - W03L01 - PA2
# Movie prediction testing

# Additional MovieData method for prediction testing
class MovieData
	# Compute predicted ratings for the first k ratings in the test set and return
	# them in a MovieTest object
	def run_test(k)
		start=Time.now
		results=MovieTest.new @test.ratings.first(k).collect{|rating| TestRating.new(
			rating.user, rating.movie, rating.rating,
			self.predict(rating.user, rating.movie))}
		time=Time.now-start
		puts "Calculated #{k} predictions in #{time.round(3)} seconds = #{(time/k).round(3)}s/prediction"
		return results
	end
end

# Stores and calculates data about predicted versus actual movie ratings
class MovieTest
	def initialize(ratings)
		@ratings=ratings
	end
	# Calculate the mean error
	def mean
		@ratings.collect {|rating| rating.predicted - rating.real}.inject(0, :+)/@ratings.count
	end
	# Calculate the standard deviation of the error
	def stddev
		mean=self.mean
		Math.sqrt(@ratings.collect {|rating| (rating.predicted - rating.real - mean)**2}.inject(0, :+)/@ratings.count)
	end
	# Calculate the root-mean-square error
	def rms
		Math.sqrt(@ratings.collect {|rating| (rating.predicted - rating.real)**2}.inject(0, :+)/@ratings.count)
	end
	# Return a list of all prections with user, movie, and actual rating
	def to_a
		@ratings.collect {|rating| [rating.user, rating.movie, rating.real, rating.predicted]}
	end
end
# One predicted rating test
class TestRating
	attr_reader :user, :movie, :real, :predicted 
	def initialize(user, movie, real, predicted)
		@user=user
		@movie=movie
		@real=real
		@predicted=predicted
	end
end
