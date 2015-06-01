require 'rails_helper'

describe "the signup process", :type => :feature do
  before :each do
    #Nothing yet, although we may need to sign users out here.
  end

  it "signs me up" do
    visit '/'
    within(".sign-up-box") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
    end
    click_button 'Sign up'
    expect(page).to have_content 'Lunches'
    expect(page).to have_content 'Date'
  end
end