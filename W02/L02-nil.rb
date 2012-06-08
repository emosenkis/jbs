#!/bin/env ruby
# Eitan Mosenkis - W02L02
# Nil profiling script
# Usage: ruby L02-nil.rb

def time(desc, reps)
	start=Time.now
	reps.times do |n|
		yield
	end
	puts "Took #{Time.now-start} sec. to #{desc} #{reps} times"
end

junk=[Time.now, true, false, nil]

time "x.nil?", 10000000 do
	junk.each {|x| x.nil?}
end
time "x == nil", 10000000 do
	junk.each {|x| x == nil}
end
