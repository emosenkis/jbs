#!/bin/env ruby
# Eitan Mosenkis - W03L01 - PA2

require 'movie_test.rb'

# One user rating (read-only, auto-type-casting)
class Rating
	attr_reader :user, :movie, :rating, :timestamp
	# Create a new Rating object with all its data
	def initialize(user,movie,rating,timestamp)
		@user=Integer(user)
		@movie=Integer(movie)
		@rating=Integer(rating)
		@timestamp=timestamp.chomp
	end
end
# One movie (read-only, auto-type-casting)
class Movie
	attr_reader :id, :title, :date, :imdb_url, :unknown, :action, :adventure, \
		:animation, :childrens, :comedy, :crime, :documentary, :drama, :fantasy, \
		:film_noir, :horror, :musical, :mystery, :romance, :sci_fi, :thriller, :war, :western
	# Create a new Movie object with all its data
	def initialize(id, title, date, imdb_url, unknown, action, adventure,\
		animation, childrens, comedy, crime, documentary, drama, fantasy, film_noir, \
		horror, musical, mystery, romance, sci_fi, thriller, war, western)
		@id=Integer(id)
		@title=title
		@date=date
		@imdb_url=imdb_url
		@unknown=Integer(unknown)==1
		@action=Integer(action)==1
		@adventure=Integer(adventure)==1
		@animation=Integer(animation)==1
		@childrens=Integer(childrens)==1
		@comedy=Integer(comedy)==1
		@crime=Integer(crime)==1
		@documentary=Integer(documentary)==1
		@drama=Integer(drama)==1
		@fantasy=Integer(fantasy)==1
		@film_noir=Integer(film_noir)==1
		@horror=Integer(horror)==1
		@musical=Integer(musical)==1
		@mystery=Integer(mystery)==1
		@romance=Integer(romance)==1
		@sci_fi=Integer(sci_fi)==1
		@thriller=Integer(thriller)==1
		@war=Integer(war)==1
		@western=Integer(western)==1
	end
end
# Represents a base set of movie data and a test set
class MovieData
	# Read data from the given directory. If subset is given, read <subset>.base and <subset>.test.
	# Otherwise, just read u.data and leave the test set empty
	def initialize(dir, subset=nil)
		@dir=dir
		if subset.nil? then
			@base=MovieDataSet.new(dir+'/'+'u.data')
			@test=nil
		else
			@base=MovieDataSet.new(dir+'/'+subset.to_s+'.base')
			@test=MovieDataSet.new(dir+'/'+subset.to_s+'.test')
		end
	end
	# Load movie details from the u.item file in the directory provided to MovieData.new
	def load_movie_data
		@movie_info=[]
		File.open(@dir+'/'+"u.item", encoding: 'iso-8859-1') do |f|
			f.each do |line|
				id, title, date, imdb_url, unknown, action, adventure, \
					animation, childrens, comedy, crime, documentary, \
					drama, fantasy, film_noir, horror, musical, mystery, \
					romance, sci_fi, thriller, war, western=line.chomp.split('|')
				# Create a Movie object and index it by id
				@movie_info[Integer(id)]=Movie.new(id, title, date, imdb_url, \
					unknown, action, adventure, animation, childrens, comedy, \
					crime, documentary, drama, fantasy, film_noir, horror, \
					musical, mystery, romance, sci_fi, thriller, war, western)
			end
		end
	end
	# Get the info of a movie given its id
	def info(movie)
		return @movie_info[movie]
	end
	# Delegated to the base set (MovieDataSet.rating)
	def rating(user, movie)
		@base.rating(user,movie)
	end
	# Delegated to the base set (MovieDataSet.predict)
	def predict(user, movie)
		@base.predict(user, movie)
	end
	# Delegated to the base set (MovieDataSet.movies)
	def movies(user)
		@base.movies(user)
	end
	# Delegated to the base set (MovieDataSet.viewers)
	def viewers(movie)
		@base.viewers(movie)
	end
end
# Loads one MovieLens data file and provides data based on it
class MovieDataSet
	# Load data from the given file
	def initialize(file)
		@movies={}
		@users={}
		@ratings=[]
		start=Time.now
		count=0
		File.open(file, encoding: 'iso-8859-1') do |f|
			f.each do |line|
				count+=1
				user, movie, rating, timestamp = line.chomp.split("\t")
				# Create a Rating object and index it by movie and user
				rating=Rating.new(user, movie, rating, timestamp)
				@ratings << rating
				if @movies[rating.movie] == nil then
					@movies[rating.movie]=[rating]
				else
					@movies[rating.movie] << rating
				end
				if @users[rating.user] == nil then
					@users[rating.user]=[rating]
				else
					@users[rating.user] << rating
				end
			end
		end
		puts "Read #{count} ratings of #{@movies.length} movies by #{@users.length} users in #{(Time.now-start).round(3)} seconds"
	end
	# To calculate popularity of a movie, sum all the reviews, subtracting 2.5 from each
	# to penalize movies with bad reviews
	def popularity(movie_id)
		@movies[movie_id].collect {|review| review.rating-2.5}.inject(0, :+)
	end
	# Calculate the popularity of all movies, then sort
	def popularity_list
		pops=[]
		@movies.keys.each {|movie| pops << [movie, popularity(movie)]}
		pops.sort_by! {|movie, popularity| -popularity}
		return pops.collect{|movie, popularity| movie}
	end
	# Calculate similarity of users based on how similar their ratings are of movies they both saw
	def similarity(user1, user2)
		ratings={}
		@users[user1].each{|rating| ratings[rating.movie]=rating.rating}
		similarity=0
		@users[user2].each do |rating|
			if ratings[rating.movie] != nil
				similarity+=(2-(ratings[rating.movie]-rating.rating).abs)/2.0
			end
		end
		return similarity
	end
	# Compare one user to all other users then return those with similarity > 0
	def most_similar(user)
		sims=[]
		@users.keys.each do |other|
			if user != other then
				sim=similarity(user, other)
				if sim > 0 then
					sims << [other, sim]
				end
			end
		end
		sims.sort_by! {|other, sim| -sim}
		return sims.collect{|other, sim| other}
	end
	# Return the rating the given user gave the given movie, or 0 if user did not rate movie
	def rating(user, movie)
		@users[user].each do |rat|
			if rat.movie == movie then
				return rat.rating
			end
		end
		return 0
	end
	# Guess what rating user would give to movie as a weighted average of the ratings given
	# to the movie by similar users
	def predict(user, movie)
		similarity_scores=self.most_similar(user).collect {|other|
			rating=self.rating(other, movie)
			rating == 0 ? nil : [self.similarity(user, other), rating]
		}.compact
		if similarity_scores.count == 0
			return 0
		end
		return similarity_scores.collect {|weight, rating| weight*rating}.inject(0, :+)/
			similarity_scores.collect {|weight, rating| weight}.inject(0, :+)
	end
	# Get the list of movies watched by a user
	def movies(user)
		@users[user].collect {|rating| rating.movie}
	end
	# Get the list of users that watched a movie
	def viewers(movie)
		@movies[movie].collect {|rating| rating.user}
	end
end

if __FILE__ == $0 then
	md=MovieData.new('ml-100k', :u1)
	md.load_movie_data
	mt=md.run_test(20000)
	puts "Mean: #{mt.mean}; stddev: #{mt.stddev}; rms: #{mt.rms}"
end
