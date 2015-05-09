class MenuController < ApplicationController

  def date_generator(y,m,d)
    (Date.today..Time.new(y,m,d).to_date).map{|date| date.strftime("%Y-%m-%d")}
  end 


  def index
    @menus = Menu.all

    @lunches = Lunch.all #Later, the choices will have a day_id, so I can make sure that a user will have all day IDs possible. 
#     User.where(weekly_subscriber: true).find_each do |user|
#   NewsMailer.weekly(user).deliver_now
# end
@lunches_by_day = []
(date_generator(2015,07,01)).each do |d|
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
