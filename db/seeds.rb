# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Khoi', :email => 'pvkhoi@apcs.vn', :password => 'aaaaaaaa', :password_confirmation => 'aaaaaaaa'
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Khanh', :email => 'nhkhanh@apcs.vn', :password => 'aaaaaaaa', :password_confirmation => 'aaaaaaaa'
puts 'New user created: ' << user2.name

puts 'SETTING UP DEFAULT MULTIPLE CHOICE QUESTIONS'
question1 = MultipleChoiceQuestion.create! :question => 'What color is the sun?', :answers => ['Red', 'Green', 'Blue', 'Pink', 'Purple'], :right_answer => 0
puts 'Question 1 created: ' << question1.question
question2 = MultipleChoiceQuestion.create! :question => 'Which country won the 2010 World Cup?', :answers => ['Vietnam', 'England', 'Spain', 'Germany', 'Brazil', 'Holland', 'Argentina', 'Italia'], :right_answer => 2
puts 'Question 2 created: ' << question2.question
