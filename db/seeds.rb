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
     first_name:     Faker::Name.name.split(' ')[0],
     last_name:     Faker::Name.name.split(' ')[1],
     email:    Faker::Internet.email,
     password: "password",#Faker::Lorem.characters(10),
   )
   user.save! 
end 
parents = User.all 

def create_faculty_sample 
  user = User.new(
    first_name:  Faker::Name.name.split(' ')[0],
    last_name:  Faker::Name.name.split(' ')[1],
    email:    Faker::Internet.email,
    password: "password",#Faker::Lorem.characters(10),
    grade: [nil, "threes", "k", "4", "6", "7", nil].sample,
    role: "faculty" #([true, false].sample ? "faculty" : "student")
   )
  user.choose_campus
  user.define_menu_id
  user.save! 
end 

#####Creating parents and faculty 

faculty = User.all.where("role = ?", 'faculty')
20.times do
  create_parent_sample
 end
40.times do 
  create_faculty_sample
end 

#####Creating children 

parents.each do |parent| 
  parent.children.create(grade: Child::GRADES.sample, first_name: Faker::Address.state, last_name: Faker::Address.city_prefix )
end 
children = Child.all

children.each do |child| 
    child.choose_campus
end 

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

menus = Menu.all 

date = menus[0].lunch_date_list[0]

Summary.create!(date: date, name: "All Faculty") 
Summary.create!(date: date, name: "DWT Students")
Summary.create!(date: date, name: "ECD Teachers")
Summary.create!(date: date, name: "ECD Students")
Summary.create!(date: date, name: "DWT Students and Teachers (list)")
Summary.create!(date: date, name: "ECD Teachers (list)")
Summary.create!(date: date, name: "ECD Staff (list)")
Summary.create!(date: date, name: "ECD Students (list)")
Summary.create!(date: date, name: "Grand Totals")





 admin = User.new(
   first_name: 'Admin',
   last_name:  'User',
   email:      'admin@example.com',
   password:   'password',
   role:       'admin'
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
  print "#{user.first_name}'s email: #{user.email}."
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

