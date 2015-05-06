class MenuController < ApplicationController
  def index
    @menus = Menu.all

    @lunches = Lunch.all #Later, the choices will have a day_id, so I can make sure that a user will have all day IDs possible. 
#     User.where(weekly_subscriber: true).find_each do |user|
#   NewsMailer.weekly(user).deliver_now
# end
@lunches_by_day = []
[Date.today, Date.tomorrow].each do |d|
  @lunches_by_day << Lunch.by_day(d).load.to_a
end
@lunches_by_day.flatten!
    @user = current_user
  end
  
  def new
    @menu = Menu.new
  end

  def show
    @menu = Menu.find(params[:id])
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
