#!/bin/env ruby

junk=[Time.now, true, false, nil]
reps=10000000

start=Time.now
reps.times do |n|
	junk.each {|x| x.nil?}
end
puts "Took #{Time.now-start} sec. for x.nil? to repeat #{reps} times"

start=Time.now
reps.times do |n|
	junk.each {|x| x == nil}
end
puts "Took #{Time.now-start} sec. for x == nil to repeat #{reps} times"
