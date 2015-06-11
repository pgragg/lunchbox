class SummariesController < ApplicationController
  def index
    @users = User.all 
    @menus = Menu.all 
    # @menu1 = Menu.find(1)
    # @menu2 = Menu.find(2)
    # @menu3 = Menu.find(3)
    # @menu4 = Menu.find(4)
    @users1 = User.where("menu_id = ?", 1)
    @users2 = User.where("menu_id = ?", 2)
    @users3 = User.where("menu_id = ?", 3)
    @users4 = User.where("menu_id = ?", 4)

  end

  def grand_totals
    @users = User.all 
    #self.lunches.by_day(date).load.to_a 
  end


end


# Add lunch summaries pages (2.0) ECD students, ECD faculty, DWT students, DWT faculty, 
# Grand totals.; 