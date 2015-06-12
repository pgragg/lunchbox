class MenuController < ApplicationController


  def define_user
    if current_user.children.count >= 1
      @child = current_user.children.find(params[:child_id])
    end
    @user = (current_user.role == "faculty" ? current_user : @child)
  end 


  def index
    @menus = Menu.all #Later, the choices will have a day_id, so I can make sure that a user will have all day IDs possible. 
#    User.where(weekly_subscriber: true).find_each do |user|
#   NewsMailer.weekly(user).deliver_now
# end
    define_user
  end
  
  def new
    @menu = Menu.new
    authorize @menu
  end

  def show
    define_user

    if @user.menu_id != 2 && @user.menu_id != 4 && @user.role == "admin"
      @menu = Menu.find(params[:id])
    else 
      @menu = Menu.find(@user.menu_id)
    end
    
    @dates = @menu.lunch_date_list
#Makes an array of dates on which lunches exist. 
    # @lunches_by_day = @menu.lunch_for_the_day 
    # @lunches_by_day.flatten!
    # authorize @menu
    # render :menu 
    
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def update
    @menu = Menu.find(params[:id])
    authorize @menu
  end

  def create
  end
end
