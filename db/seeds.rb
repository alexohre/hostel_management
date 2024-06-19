# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "creating user"
User.create!(email: "hello@test.com", password: "password")
puts "user created"

acc = Account.create!(email: "ella@rose.com", password: 123456, mat_no: "com/ahnd/2024/00234" )
puts "Account created"


puts "creating hostel type.."
HostelType.create!([{name: "Male Hostel"}, {name: "Female Hostel"}])
puts "hostel type created!"


