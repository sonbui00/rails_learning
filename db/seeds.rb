# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: 'Example User',
             email: 'example@example.com',
             password: '123456',
             password_confirmation: '123456',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
99.times do |n|
  User.create!(name: Faker::Name.name,
              email: "example#{n}@example.com",
              password: '123456',
              password_confirmation: '123456',
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take 6
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user = User.first

following = users[2..40]
followers = users[3..50]

following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
