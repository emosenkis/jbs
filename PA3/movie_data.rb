#!/bin/env ruby
# Eitan Mosenkis - W03L01 - PA2
# Usage: load as a library or run ./movie_data.rb for a demo

load 'movie_test.rb'

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
	attr_reader :id, :title, :date, :video_date, :imdb_url, :unknown, :action, :adventure, \
		:animation, :childrens, :comedy, :crime, :documentary, :drama, :fantasy, \
		:film_noir, :horror, :musical, :mystery, :romance, :sci_fi, :thriller, :war, :western
	# Create a new Movie object with all its data
	def initialize(id, title, date, video_date, imdb_url, unknown, action, adventure,\
		animation, childrens, comedy, crime, documentary, drama, fantasy, film_noir, \
		horror, musical, mystery, romance, sci_fi, thriller, war, western)
		@id=Integer(id)
		@title=title
		@date=date
		@video_date=video_date
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
	def genres
		[@unknown, @action, @adventure, @animation, @childrens, @comedy, @crime,
			@documentary, @drama, @fantasy, @film_noir, @horror, @musical,
			@mystery, @romance, @sci_fi, @thriller, @war, @western]
	end
	def has_genre?(genre_id)
		self.genres[genre_id]
	end
end

# One user (read-only, auto-type-casting)
class User
	attr_reader :id, :age, :gender, :occupation, :zip_code
	def initialize(id, age, gender, occupation, zip_code)
		@id=Integer(id)
		@age=Integer(age)
		@gender=gender.to_sym
		@occupation=occupation.to_sym
		@zip_code=zip_code
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
		load_movie_data
		load_user_data
	end
	# Load movie details from the u.item file in the directory provided to MovieData.new
	def load_movie_data
		@movie_info=[]
		File.open(@dir+'/'+"u.item", encoding: 'iso-8859-1') do |f|
			f.each do |line|
				id, title, date, video_date, imdb_url, unknown, action, adventure, \
					animation, childrens, comedy, crime, documentary, \
					drama, fantasy, film_noir, horror, musical, mystery, \
					romance, sci_fi, thriller, war, western=line.chomp.split('|')
				# Create a Movie object and index it by id
				@movie_info[Integer(id)]=Movie.new(id, title, date, video_date, imdb_url, \
					unknown, action, adventure, animation, childrens, comedy, \
					crime, documentary, drama, fantasy, film_noir, horror, \
					musical, mystery, romance, sci_fi, thriller, war, western)
			end
		end
	end
	# Load user details from the u.user file in the directory provided to MovieData.new
	def load_user_data
		@user_info=[]
		File.open(@dir+'/'+"u.user", encoding: 'iso-8859-1') do |f|
			f.each do |line|
				id, age, gender, occupation, zip_code = line.chomp.split('|')
				@user_info[Integer(id)]=User.new(id, age, gender, occupation, zip_code)
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
	# Finds movies filtered by title, date, and/or genre
	def find_movies(query)
		movies=@movie_info.compact
		if query[:title]
			movies.select! {|movie| movie.title.downcase.include? query[:title].downcase}
		end
		if query[:genre]
			if query[:genre].class == Fixnum then
				movies.select! {|movie| movie.has_genre? query[:genre]}
			else
				movies.select! {|movie| movie.method(query[:genre]).call}
			end
		end
		if query[:date]
			movies.select! {|movie| movie.date.include? query[:date].to_s}
		end
		movies.collect {|movie| movie.id}
	end
	# Finds users filtered by occupation, age, and/or sex
	def find_users(query)
		users=@user_info.compact
		if query[:occupation]
			users.select! {|user| user.occupation == query[:occupation].to_sym}
		end
		if query[:age]
			users.select! {|user| user.age >= query[:age][0] && user.age <= query[:age][1]}
		end
		if query[:sex]
			users.select! {|user| user.gender == query[:sex].to_sym}
		end
		users.collect {|user| user.id}
	end
	# Gets all movies from the given genre and year
	def test1(genre, year)
		find_movies genre: genre, date: year
	end
	# Gets the n most popular movies for viewers from the given age range and sex
	def test2(agerange, sex, n)
		users=find_users age: agerange, sex: sex
		data_set=MovieDataSet.new(@base.ratings.select {|rating| users.include? rating.user})
		data_set.popularity_list.first(n)
	end
end
# Loads one MovieLens data file and provides data based on it
class MovieDataSet
	attr_reader :ratings
	# Load data from the given file
	def initialize(data)
		@movies={}
		@users={}
		@ratings=[]
		start=Time.now
		if data.class == String then
			File.open(data, encoding: 'iso-8859-1') do |f|
				f.each do |line|
					user, movie, rating, timestamp = line.chomp.split("\t")
					# Create a Rating object and index it by movie and user
					rating=Rating.new(user, movie, rating, timestamp)
					@ratings << rating
				end
			end
		else
			@ratings = data
		end
		@ratings.each do |rating|
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
		puts "Processed #{@ratings.length} ratings of #{@movies.length} movies by #{@users.length} users in #{(Time.now-start).round(3)} seconds"
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
				similarity+=(1-(ratings[rating.movie]-rating.rating).abs)/2.0
			end
		end
		return similarity
	end
	# Compare one user to all other users then return those with similarity > 0
	def most_similar(user, with_score=false)
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
		return with_score ? sims : sims.collect{|other, sim| other}
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
		numerator=0
		denominator=0
		self.most_similar(user, true).each {|other, sim|
			rating=self.rating(other, movie)
			if rating != 0 then
				numerator+=rating*sim
				denominator+=sim
			end
		}
		return denominator == 0 ? 3 : numerator/denominator
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
	md=MovieData.new('ml-100k', :u4)
	md.load_movie_data
	mt=md.run_test(100)
	puts "Mean: #{mt.mean}; stddev: #{mt.stddev}; rms: #{mt.rms}"
end
