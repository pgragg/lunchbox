require 'faker'
require 'date' 

def flip_a_coin
  [true, false].sample
end  

# def choose_grade 
#   if self.campus == "DWT"
#     Random.rand(1..7)
#   else 
#     determinant = Random.rand(1..3)
#     "k" if determinant == 3
#     "4s" if determinant == 2
#     "3s" if determinant == 1
#   end 
# end 

Lunch.delete_all
User.delete_all #Deleting all your data before a reset is pretty much necessary. 
Menu.delete_all 


def create_user_sample 
  user = User.new(
     name:     Faker::Name.name,
     email:    Faker::Internet.email,
     password: "Changeme2015",#Faker::Lorem.characters(10),
     campus:  ([true, false].sample ? "DWT" : "ECD"),
     #role: "" #([true, false].sample ? "faculty" : "student")
   )
   # user.choose_grade # If I try to make this contingent on the user being a certain kind of user, the CAMPUS gets screwed up (possible "t" or "f" instead of "DWT" or "ECD")
   #user.skip_confirmation!
   # user.choose_role
  # user.choose_menu_id


   user.save! 
end 






90.times do
   create_user_sample
 end
 users = User.all

Menu.create!(
  name: "Dwight Faculty Menu"
  )

Menu.create!(
  name: "Dwight Student Menu"
  )
 
Menu.create!(
  name: "ECD Faculty Menu"
  )
 
Menu.create!(
  name: "ECD Student Menu"
  )
 
menus = Menu.all


5.times do 
  Summary.create!(
    date: Date.today)
end 

i = 0 
30.times do #30 days of lunches created
  i += 1
  6.times do #6 lunches a day for all menus
    m = 0 
    date = Date.today + i 
    name = Faker::Commerce.product_name
   4.times do #4 menus all have the same lunch 
     menu = menus[m]  
      Lunch.create!(
       date: date,   #Faker::Date.between(Date.today + 3, Date.today + 10)
       name: name,
       menu: menu 
     )
     m += 1
   end 
  end
end 


 # users.each do |user|
 #  unless user.role == "admin"

 #    menu_id = user.menu_id
 #    menu = Menu.find(menu_id)
 #    lunches = Lunch.all.by_menu(menu_id)
 #    menu.lunch_date_list.each do |date|
 #      lunch = menu.lunches.by_day(date).sample
 #      LunchChoice.build_choice(lunch, user, date) 
 #    end 
 #    user.save!
 # end 


user = User.new(
     name:     "Piper Gragg",
     email:    "pipergragg@gmail.com",
     password: "password",#Faker::Lorem.characters(10),
     campus:  (flip_a_coin ? "DWT" : "ECD"),
     role: "faculty"
   )
  
   user.define_menu_id # If I try to make this contingent on the user being a certain kind of user, the CAMPUS gets screwed up (possible "t" or "f" instead of "DWT" or "ECD")
   #user.skip_confirmation!

   user.save!



 admin = User.new(
   name:     'Admin User',
   email:    'admin@example.com',
   password: 'password',
   role:     'admin'
 )
 #admin.skip_confirmation!
 admin.save!

population = User.all 

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Lunch.count} lunches created"
puts "#{Menu.count} menus created"
puts "--------------------------------"
puts "Created the following users"

population.each do |user|
  print "#{user.name}'s email: #{user.email}."
  if user.role != nil 
    print "(**#{user.role}**)"
  end 
  puts "At #{user.campus}, with menu_id #{user.menu_id}"
  puts "has #{user.lunch_choices.count} lunch choices"
  puts ""
end 

puts "#{LunchChoice.count} lunch choices created"
puts "#{LunchChoice.count/User.count} lunch choices per user"
puts "#{User.all.by_campus("ECD").count} ECD, #{User.all.by_campus("DWT").count} DWT"

