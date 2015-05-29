describe "the signin process", :type => :feature do
  before :each do
    User.make(:email => 'user@example.com', :password => 'password') #Devise wiki has FG examples etc.
  end

  it "signs me in" do
    visit '/'
    within(".sign-in-box") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Lunches'
  end
end