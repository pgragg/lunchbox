


FactoryGirl.define do
   factory :lunch do
     name "Refried Beans"
     description "These beans are a serious dream team."
     date "Wed, 20 May 2015"

     # factory :user_with_post_and_comment do
     #    after :build do |user|
     #      post = create(:post, user: user)
     #      create(:comment, user: user, post: post) #your code worked, but this is a bit more compact
     #    end
     # end
    # after(:create) do |lunch, factory|
    #   if factory.chosen_by
    #     FactoryGirl.create(:user_chose_lunch, lunch: lunch, user: factory.chosen_by)
    #   end
    # end
    end
  end