FactoryGirl.define do
   factory :user do
     name "Douglas Adams"
     sequence(:email, 100) { |n| "person#{n}@example.com" }
     password "helloworld"
     password_confirmation "helloworld"

     factory :user_chose_lunch do
        after :build do |user|
          lunch_choice.create(:lunch, user: user)
        end
     end
     factory :admin_user do 
        role = "admin"
        after :build do |user|
          puts "Admin user's email is #{user.email}"
        end 
     end
    end
  end
