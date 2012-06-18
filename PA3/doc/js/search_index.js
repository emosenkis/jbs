var search_data = {"index":{"searchIndex":["movie","moviedata","moviedataset","movietest","rating","testrating","user","find_movies()","find_users()","genres()","has_genre?()","info()","load_movie_data()","load_user_data()","mean()","most_similar()","movies()","movies()","new()","new()","new()","new()","new()","new()","new()","popularity()","popularity_list()","predict()","predict()","rating()","rating()","rms()","run_test()","similarity()","stddev()","test1()","test2()","to_a()","viewers()","viewers()","readme","transcript"],"longSearchIndex":["movie","moviedata","moviedataset","movietest","rating","testrating","user","moviedata#find_movies()","moviedata#find_users()","movie#genres()","movie#has_genre?()","moviedata#info()","moviedata#load_movie_data()","moviedata#load_user_data()","movietest#mean()","moviedataset#most_similar()","moviedata#movies()","moviedataset#movies()","movie::new()","moviedata::new()","moviedataset::new()","movietest::new()","rating::new()","testrating::new()","user::new()","moviedataset#popularity()","moviedataset#popularity_list()","moviedata#predict()","moviedataset#predict()","moviedata#rating()","moviedataset#rating()","movietest#rms()","moviedata#run_test()","moviedataset#similarity()","movietest#stddev()","moviedata#test1()","moviedata#test2()","movietest#to_a()","moviedata#viewers()","moviedataset#viewers()","",""],"info":[["Movie","","Movie.html","","<p>One movie (read-only, auto-type-casting)\n"],["MovieData","","MovieData.html","","<p>Represents a base set of movie data and a test set\n<p>Additional MovieData method for prediction testing …\n"],["MovieDataSet","","MovieDataSet.html","","<p>Loads one MovieLens data file and provides data based on it\n"],["MovieTest","","MovieTest.html","","<p>Stores and calculates data about predicted versus actual movie ratings\n"],["Rating","","Rating.html","","<p>One user rating (read-only, auto-type-casting)\n"],["TestRating","","TestRating.html","","<p>One predicted rating test\n"],["User","","User.html","","<p>One user (read-only, auto-type-casting)\n"],["find_movies","MovieData","MovieData.html#method-i-find_movies","(query)","<p>Finds movies filtered by title, date, and/or genre\n"],["find_users","MovieData","MovieData.html#method-i-find_users","(query)","<p>Finds users filtered by occupation, age, and/or sex\n"],["genres","Movie","Movie.html#method-i-genres","()",""],["has_genre?","Movie","Movie.html#method-i-has_genre-3F","(genre_id)",""],["info","MovieData","MovieData.html#method-i-info","(movie)","<p>Get the info of a movie given its id\n"],["load_movie_data","MovieData","MovieData.html#method-i-load_movie_data","()","<p>Load movie details from the u.item file in the directory provided to\nMovieData.new\n"],["load_user_data","MovieData","MovieData.html#method-i-load_user_data","()","<p>Load user details from the u.user file in the directory provided to\nMovieData.new\n"],["mean","MovieTest","MovieTest.html#method-i-mean","()","<p>Calculate the mean error\n"],["most_similar","MovieDataSet","MovieDataSet.html#method-i-most_similar","(user, with_score=false)","<p>Compare one user to all other users then return those with similarity &gt;\n0\n"],["movies","MovieData","MovieData.html#method-i-movies","(user)","<p>Delegated to the base set (MovieDataSet.movies)\n"],["movies","MovieDataSet","MovieDataSet.html#method-i-movies","(user)","<p>Get the list of movies watched by a user\n"],["new","Movie","Movie.html#method-c-new","(id, title, date, video_date, imdb_url, unknown, action, adventure,\\ animation, childrens, comedy, crime, documentary, drama, fantasy, film_noir, \\ horror, musical, mystery, romance, sci_fi, thriller, war, western)","<p>Create a new Movie object with all its data\n"],["new","MovieData","MovieData.html#method-c-new","(dir, subset=nil)","<p>Read data from the given directory. If subset is given, read\n&lt;subset&gt;.base and &lt;subset&gt;.test. …\n"],["new","MovieDataSet","MovieDataSet.html#method-c-new","(data)","<p>Load data from the given file\n"],["new","MovieTest","MovieTest.html#method-c-new","(ratings)",""],["new","Rating","Rating.html#method-c-new","(user,movie,rating,timestamp)","<p>Create a new Rating object with all its data\n"],["new","TestRating","TestRating.html#method-c-new","(user, movie, real, predicted)",""],["new","User","User.html#method-c-new","(id, age, gender, occupation, zip_code)",""],["popularity","MovieDataSet","MovieDataSet.html#method-i-popularity","(movie_id)","<p>To calculate popularity of a movie, sum all the reviews, subtracting 2.5\nfrom each to penalize movies …\n"],["popularity_list","MovieDataSet","MovieDataSet.html#method-i-popularity_list","()","<p>Calculate the popularity of all movies, then sort\n"],["predict","MovieData","MovieData.html#method-i-predict","(user, movie)","<p>Delegated to the base set (MovieDataSet.predict)\n"],["predict","MovieDataSet","MovieDataSet.html#method-i-predict","(user, movie)","<p>Guess what rating user would give to movie as a weighted average of the\nratings given to the movie by …\n"],["rating","MovieData","MovieData.html#method-i-rating","(user, movie)","<p>Delegated to the base set (MovieDataSet.rating)\n"],["rating","MovieDataSet","MovieDataSet.html#method-i-rating","(user, movie)","<p>Return the rating the given user gave the given movie, or 0 if user did not\nrate movie\n"],["rms","MovieTest","MovieTest.html#method-i-rms","()","<p>Calculate the root-mean-square error\n"],["run_test","MovieData","MovieData.html#method-i-run_test","(k)","<p>Compute predicted ratings for the first k ratings in the test set and\nreturn them in a MovieTest object …\n"],["similarity","MovieDataSet","MovieDataSet.html#method-i-similarity","(user1, user2)","<p>Calculate similarity of users based on how similar their ratings are of\nmovies they both saw\n"],["stddev","MovieTest","MovieTest.html#method-i-stddev","()","<p>Calculate the standard deviation of the error\n"],["test1","MovieData","MovieData.html#method-i-test1","(genre, year)","<p>Gets all movies from the given genre and year\n"],["test2","MovieData","MovieData.html#method-i-test2","(agerange, sex, n)","<p>Gets the n most popular movies for viewers from the given age range and sex\n"],["to_a","MovieTest","MovieTest.html#method-i-to_a","()","<p>Return a list of all prections with user, movie, and actual rating\n"],["viewers","MovieData","MovieData.html#method-i-viewers","(movie)","<p>Delegated to the base set (MovieDataSet.viewers)\n"],["viewers","MovieDataSet","MovieDataSet.html#method-i-viewers","(movie)","<p>Get the list of users that watched a movie\n"],["README","","ml-100k/README.html","","<p>SUMMARY &amp; USAGE LICENSE\n<p>\n<p>MovieLens data sets were collected by the GroupLens Research Project at the\n…\n"],["transcript","","transcript_txt.html","","<p>&gt;&gt; load ‘movie_data.rb’ #=&gt; true &gt;&gt;\nmd=MovieData.new(‘ml-100k’); nil #=&gt; nil Processed …\n"]]}}