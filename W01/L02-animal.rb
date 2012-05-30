#!/bin/env ruby
# Eitan Mosenkis - W1L02
# Animal game - plays a yes/no guessing game to figure out what animal
# the user is thinking of. It uses a simple binary tree to store it's
# knowledge, which is given by the user when it loses.
# Usage: ./animal.rb

# Define the question class - it has a question and two answers
class Question
	attr_accessor :q, :yes, :no
	def initialize(q, yes, no)
		@q=q
		@yes=yes
		@no=no
	end
end

# Starting state - one question, two animals
root=Question.new("Is it a mammal?", "Elephant", "Frog")
# Repeat the game forever until the user uses Ctrl-C to exit
while true do
	# Start at the root
	cur=root
	parent=nil
	# Ask questions as long as possible
	while (!cur.is_a?(String)) do
		parent=cur
		puts cur.q
		if gets[0,1].downcase == 'y' then
			cur=cur.yes
		else
			cur=cur.no
		end
	end
	# Tell the user our guess and ask if it's right
	puts "Is it a #{cur}?"
	if gets[0,1].downcase == 'y' then
		puts "I win!"
	else
		# Find out the right answer
		puts "What is it?"
		new_animal=gets.chomp
		# Get a way to differentiate
		puts "What question would be true for a #{new_animal} but false for a #{cur}?"
		# Create a new question object
		new_q=Question.new(gets.chomp, new_animal, cur)
		# Replace our guess with the new question and it's two possible answers
		if parent.yes == cur then
			parent.yes=new_q
		else
			parent.no=new_q
		end
		puts "Thanks. Now I'll be sure to win next time."
	end
	# Print a blank line to separate games
	puts ""
end
