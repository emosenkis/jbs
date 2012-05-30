#!/bin/env ruby
# Eitan Mosenkis - JBS pre-homework
# Usage:
# ./secret.rb < input
# This script takes a list of people on STDIN with the format:
# <first> <last> <<email@addr.ess>>
# It then pairs people so that each person is assigned someone
# else with a different last name, and emails them with their
# assignment.
# This script depends on having an SMTP server running on localhost:25
# that does not require authentication.

# Separate stdin into people, make pairs of people
pairs=STDIN.readlines.collect{|x| [x.split, x.split]}
i=0
# Until the condition is met, randomly swap people
while i<pairs.length do
	if pairs[i][0][1] == pairs[i][1][1] then
		swap=rand(pairs.length)
		tmp=pairs[i][1]
		pairs[i][1]=pairs[swap][1]
		pairs[swap][1]=tmp
		i=-1
	end
	i=i+1
end
# Email sending based on http://www.tutorialspoint.com/ruby/ruby_sending_email.htm
require 'net/smtp'
pairs.each do |p|
	message = <<MESSAGE_END
From: Game Master <game_master@mosenkis.net>
To: #{p[0][0]} #{p[0][1]} <#{p[0][2]}>
Subject: Your Assignment

You must give a gift to #{p[1][0]} #{p[1][1]}. Enjoy!
MESSAGE_END

	Net::SMTP.start('localhost') do |smtp|
		smtp.send_message message, 'game_master@mosenkis.net', p[0][2]
	end
	puts "#{p[0][0]} #{p[0][1]} -> #{p[1][0]} #{p[1][1]}"
end
