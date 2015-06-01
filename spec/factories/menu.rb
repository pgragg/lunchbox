FactoryGirl.define do
   factory :menu do
    created_at "May 01, 2015"
     
     factory :menu_with_lunch do
        after :save do |menu|
          lunch = FactoryGirl.create(:lunch)
          menu.lunches = Lunch.all
        end
    # after(:create) do |lunch, factory|
    #   if factory.chosen_by
    #     FactoryGirl.create(:user_chose_lunch, lunch: lunch, user: factory.chosen_by)
    #   end
    # end
     end
    end
end