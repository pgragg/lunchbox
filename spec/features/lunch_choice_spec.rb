require 'rails_helper'
RSpec.feature "Lunch Choice", :type => :feature do
  describe Menu
    describe "user signin", :type => :feature do

      def lunch_date_list(menu)
        dates = Array.new 
        menu.lunches.each {|lunch| dates << lunch.date}
        dates.uniq! 
      end 

      before :each do 
        user = FactoryGirl.create(:admin_user)
        login_as(user, :scope => :user)
        lunch = FactoryGirl.create(:lunch)
        menu = FactoryGirl.create(:menu_with_lunch)
        FactoryGirl.create(:lunch_choice, lunch: lunch, chosen_by: user)
        @dates =  lunch_date_list(menu)
      end 


      it "shows main lunch menu" do
        visit '/menu'
        expect(page).to have_content 'Lunches'
      end
      it "allows you to choose lunches" do
        visit '/menu'
        print page.html
        find('.unchosen').click
        expect(page).to have_content 'Edit'
      end
  end
end 