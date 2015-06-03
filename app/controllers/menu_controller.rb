class MenuController < ApplicationController


  def index
    @menus = Menu.all #Later, the choices will have a day_id, so I can make sure that a user will have all day IDs possible. 
#    User.where(weekly_subscriber: true).find_each do |user|
#   NewsMailer.weekly(user).deliver_now
# end
    @user = current_user
  end
  
  def new
    @menu = Menu.new
  end

  def show
    @menu = Menu.find(params[:id])
    @dates = @menu.lunch_date_list #Makes an array of dates on which lunches exist. 
    @lunches_by_day = @menu.lunch_for_the_day 
    @lunches_by_day.flatten!
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def update
    @menu = Menu.find(params[:id])
  end

  def create
  end
end
