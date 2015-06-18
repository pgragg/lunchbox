require 'faker'
require 'date' 

def flip_a_coin
  [true, false].sample
end  

Lunch.delete_all
User.delete_all #Deleting all your data before a reset is pretty much necessary. 
Menu.delete_all 
Child.delete_all
LunchChoice.delete_all
Summary.delete_all

def create_parent_sample 
  user = User.new(
     name:     Faker::Name.name,
     email:    Faker::Internet.email,
     password: "password",#Faker::Lorem.characters(10),
   )
   user.save! 
end 
parents = User.all 

def create_faculty_sample 
  user = User.new(
     name:     Faker::Name.name,
     email:    Faker::Internet.email,
     password: "password",#Faker::Lorem.characters(10),
     campus:  ([true, false].sample ? "DWT" : "ECD"),
     role: "faculty" #([true, false].sample ? "faculty" : "student")
   )
   user.define_menu_id
   user.save! 
end 

#####Creating parents and faculty 

faculty = User.all.where("role = ?", 'faculty')
20.times do
   create_parent_sample
   create_faculty_sample
 end

#####Creating children 

 parents.each do |parent| 
  parent.children.create(grade: 'threes', campus:'ECD')
  parent.children.create(grade: '4', campus:'DWT')
  parent.children.create(grade: '7', campus:'DWT')
 end 

 children = Child.all

#####Creating menus 

Menu.create!(name: "Dwight Faculty Menu")
Menu.create!(name: "Dwight Student Menu")
Menu.create!(name: "ECD Faculty Menu")
Menu.create!(name: "ECD Student Menu")
menus = Menu.all


#####Creating lunches 

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

######Ordering lunches for children and faculty

children.each do |child|
   menu = Menu.find(child.menu_id)
   i = 0
   29.times do 
     date = menu.lunch_date_list[i]
     child.lunch_choices.create(lunch: menu.lunches.by_day(date)[rand(0..5)], date: date)
     i += 1
   end
 end 

 faculty.each do |fac|
   menu = Menu.find(fac.menu_id)
   i = 0
   29.times do 
     date = menu.lunch_date_list[i]
     fac.lunch_choices.create(lunch: menu.lunches.by_day(date)[rand(0..5)], date: date)
     i += 1
   end
 end 

####### Creating summary models.  

Summary.create!(date: Date.today, name: "All Faculty") #This just starts the summary on a date. 
Summary.create!(date: Date.today, name: "Dwight Students")
Summary.create!(date: Date.today, name: "ECD Faculty")
Summary.create!(date: Date.today, name: "ECD Students")
Summary.create!(date: Date.today, name: "Dwight Students and Teachers (list)")
Summary.create!(date: Date.today, name: "Grand Totals")


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

