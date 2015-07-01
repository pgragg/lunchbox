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
# Year.delete_all
# Trimester.delete_all
# Holiday.delete_all

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
  user.define_campus
  user.define_menu_id
  user.save! 
end 

def create_staff_sample 
  user = User.new(
    first_name:  Faker::Name.name.split(' ')[0],
    last_name:  Faker::Name.name.split(' ')[1],
    email:    Faker::Internet.email,
    password: "password",
    grade: nil,
    role: "staff",
    campus: ["ECD", "DWT"].sample 
   )
  user.define_menu_id
  user.save! 
end 

#####Creating parents and faculty 


50.times do
  create_parent_sample
 end
40.times do 
  create_faculty_sample
  create_staff_sample
end 

faculty = User.all.where("role = ?", 'faculty')
staff = User.all.where("role = ?", 'staff')

#####Creating children 

parents.each do |parent| 
  rand(2).times do 
    parent.children.create(
      grade: Child::GRADES.sample, 
      first_name: Faker::Address.state, 
      last_name: Faker::Address.city_prefix )
  end
end 

children = Child.all

children.each do |child| 
    child.define_menu_id
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
  12.times do #6 lunches a day for all menus
    m = 0 
    date = Date.today + i 
    name = Faker::Commerce.product_name
   4.times do #4 menus all have the same lunch 
     menu = menus[m]  
      Lunch.create!(
       date: date,   #Faker::Date.between(Date.today + 3, Date.today + 10)
       name: name,
       menu: menu,
       lunch_type: ['drink', 'lunch'].sample 
     )
     m += 1
   end 
  end
end 

######Ordering lunches for children and faculty
lunch_users = [children, faculty, staff]

lunch_users.each do |unit|
  unit.each do |user|
   menu = Menu.find(user.menu_id)
   i = 0
   29.times do 
     date = menu.lunch_date_list[i]
     user.lunch_choices.create(lunch: menu.lunches.by_day(date)[rand(0..11)], date: date )
     i += 1
   end
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

