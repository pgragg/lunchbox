class SummariesController < ApplicationController
  def index
    @users = User.all 
    @menu1 = Menu.find(1)
    @menu2 = Menu.find(2)
    @menu3 = Menu.find(3)
    @menu4 = Menu.find(4)
    @users1 = @menu1.users
    @users2 = @menu2.users 
    @users3 = @menu3.users
    @users4 = @menu4.users
  end

  def grand_totals
    @users = User.all 
    


    #self.lunches.by_day(date).load.to_a 
  end
end


# Add lunch summaries pages (2.0) ECD students, ECD faculty, DWT students, DWT faculty, 
# Grand totals.; 