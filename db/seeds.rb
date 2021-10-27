# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'
require 'json'

puts "Cleaning up database..."
Booking.destroy_all
Offer.destroy_all
# Review.destroy_all
# List.destroy_all
# Movie.destroy_all
puts "Database cleaned"

good_user = User.first

10.times do |i|
  puts "creating motorcicle with faker #{i + 1}"
  good_user.offers.create(
    description: "#{Faker::Vehicle.make_and_model} #{Faker::Vehicle.color}",
    price: rand(5..15),
    lat: 10.501592,
    long: -66.910912
  )
end
puts "Offers created"
