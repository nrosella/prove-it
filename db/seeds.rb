# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(email: "nino@nino.com", password: "password123", password_confirmation: "password123", name: "nino", bio: "English")
User.create(email: "greg@greg.com", password: "password123", password_confirmation: "password123", name: "greg", bio: "Bio")
User.create(email: "travis@nino.com", password: "password123", password_confirmation: "password123", name: "travis", bio: "Georgia")
User.create(email: "mason@mason.com", password: "password123", password_confirmation: "password123", name: "mason", bio: "Epic")

Challenge.create(title: "Challenge 1", description:'A great challenge', challenge_duration: 1, voting_duration: 1)
Challenge.create(title: "Challenge 2: Electric Bugaloo", description:'Another great challenge', challenge_duration: 1, voting_duration: 1)
Challenge.create(title: "Challenge 3: Challenged Again", description:'A great challenge', challenge_duration: 1, voting_duration: 1)

UserChallenge.create(user_id: 1, challenge_id: 1, admin: true)  
UserChallenge.create(user_id: 2, challenge_id: 1)
UserChallenge.create(user_id: 3, challenge_id: 2, admin: true) 
UserChallenge.create(user_id: 4, challenge_id: 2)
UserChallenge.create(user_id: 1, challenge_id: 3, admin: true) 
UserChallenge.create(user_id: 4, challenge_id: 3) 