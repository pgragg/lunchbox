require 'faker'
require 'date' 

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


 4.times do 
  Menu.create!(
    name: Faker::Commerce.product_name
    )
  end 
  menus = Menu.all



 50.times do
   Lunch.create!(
     date: Faker::Date.between(Date.today + 3, Date.today + 10),   #date_generator(2015,06,12), #Faker::Date.forward(10),
     description: Faker::Lorem.sentences(1),
     name: Faker::Commerce.product_name,
     menu: menus.sample
   )
 end

# @month = 0 
# @year = 2015
#   12.times do  #Trying to create all the dates in the year. 
#     day = 0 
#    (Time.days_in_month(@month)).times do
#     day += 1 
#     Day.create!(date: Date.new(@year,@month,day))
#    end 
#    month += 1 
#  end

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
 puts "Created the following users"
 population.each do |user|
  print "#{user.name}'s email: #{user.email}."
  if user.role != nil 
    print "(**#{user.role}**)"
  end 
  puts ""
 end 

