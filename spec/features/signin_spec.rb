require 'rails_helper'

describe "the signin process", :type => :feature do
  before :each do
   user = FactoryGirl.create(:user, email: "user@example.com")
  end

  it "signs me in" do
    visit '/'
    within(".sign-in-box") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'helloworld'
    end
    click_button 'Log in'
    expect(page).to have_content 'Lunches'
  end
end