require 'faker'
Day.delete_all
Lunch.delete_all
User.delete_all #Deleting all your data before a reset is pretty much necessary. 
Menu.delete_all 


5.times do
   user = User.new(
     name:     Faker::Name.name,
     email:    Faker::Internet.email,
     password: Faker::Lorem.characters(10)
   )
   #user.skip_confirmation!
   user.save!
 end
 users = User.all

 1000.times do
   Lunch.create!(
     #user: users.sample,
     date: Faker::Date.forward(365),
     description: Faker::Lorem.sentences(1),
     name: Faker::Commerce.product_name
   )
 end

 admin = User.new(
   name:     'Admin User',
   email:    'admin@example.com',
   password: 'helloworld',
   role:     'admin'
 )
 #admin.skip_confirmation!
 admin.save!

population = User.all 

puts "Seed finished"
puts "#{User.count} users created"
 puts "#{Lunch.count} lunches created"
 puts "#{Menu.count} menus created"
 puts "#{Day.count} days created"
 puts "Created the following users"
 population.each do |user|
  print "#{user.name}'s email: #{user.email}."
  if user.role != nil 
    print "(**#{user.role}**)"
  end 
  puts ""
 end 

