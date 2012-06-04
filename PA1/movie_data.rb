#!/bin/env ruby
# Eitan Mosenkis - W02L01
# Movie Data - reads in data from MovieLens datasets, then does simple analysis to
# be able to assign popularity scores to movies and similarity scores to pairs of
# users.
# Usage:
# The load_data method expects to have u.item and u.data files in the current
# working directory. It can be called as ./movie_data.rb to give a demo
# or included by another script and used as a library by creating a new MovieData
# object and running its load_data method

# Rating class - basically just a struct with typecasting on init
class Rating
	attr_accessor :user, :movie, :rating, :timestamp
	def initialize(user,movie,rating,timestamp)
		@user=Integer(user)
		@movie=Integer(movie)
		@rating=Integer(rating)
		@timestamp=timestamp
	end
end
# Movie class - basically just a struct with typecasting on init
class Movie
	attr_accessor :id, :title, :date, :imdb_url, :unknown, :action, :adventure, \
		:animation, :childrens, :comedy, :crime, :documentary, :drama, :fantasy, \
		:film_noir, :horror, :musical, :mystery, :romance, :sci_fi, :thriller, :war, :western
	def initialize(id, title, date, imdb_url, unknown, action, adventure,\
		animation, childrens, comedy, crime, documentary, drama, fantasy, film_noir, \
		horror, musical, mystery, romance, sci_fi, thriller, war, western)
		@id=Integer(id)
		@title=title
		@date=date
		@imdb_url=imdb_url
		@unknown=unknown==1
		@action=action==1
		@adventure=adventure==1
		@animation=animation==1
		@childrens=childrens==1
		@comedy=comedy==1
		@crime=crime==1
		@documentary=documentary==1
		@drama=drama==1
		@fantasy=fantasy==1
		@film_noir=film_noir==1
		@horror=horror==1
		@musical=musical==1
		@mystery=mystery==1
		@romance=romance==1
		@sci_fi=sci_fi==1
		@thriller=thriller==1
		@war=war==1
		@western=western==1
	end
end
# MovieData class - loads and calculates with MovieLens data sets
class MovieData
	# Load data from the u.data and u.item files
	def load_data
		@movies={}
		@users={}
		start=Time.now
		count=0
		File.open("u.data", encoding: 'iso-8859-1') do |f|
			f.each do |line|
				count+=1
				user, movie, rating, timestamp = line.chomp.split("\t")
				# Create a Rating object and index it by movie and user
				rating=Rating.new(user, movie, rating, timestamp)
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
		@movie_info={}
		File.open("u.item", encoding: 'iso-8859-1') do |f|
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
		puts "Read #{count} ratings of #{@movies.length} movies by #{@users.length} users in #{(Time.now-start).round(3)} seconds"
	end
	# To calculate popularity of a movie, sum all the reviews, subtracting 2.5 from each
	# to penalize movies with bad reviews
	def popularity(movie_id)
		sum=0
		@movies[movie_id].each {|review| sum+=review.rating-2.5}
		return sum
	end
	# Calculate the popularity of all movies, then sort
	def popularity_list
#		start=Time.now
		pops=[]
		@movies.keys.each {|movie| pops << [movie, popularity(movie)]}
		pops.sort_by! {|movie, popularity| -popularity}
#		puts "Calculated popularity list in #{(Time.now-start).round(3)} seconds"
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
	# Compare one user to all other users then return the most similar 20
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
	# Get the info of a movie given its id
	def info(movie)
		return @movie_info[movie]
	end
end

if __FILE__ == $0 then
	md=MovieData.new
	md.load_data
	user=459
	puts "10 most similar users to user #{user} are"
	puts md.most_similar(user).first(10)
	puts "and the 10 least similar are"
	puts md.most_similar(user).last(10)
	puts "10 most popular movies are"
	md.popularity_list.first(10).each {|movie| puts md.info(movie).title}
	puts "and the 10 least popular are"
	md.popularity_list.last(10).each {|movie| puts md.info(movie).title}
end
