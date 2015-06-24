class MenuController < ApplicationController


  def delete_all_lunches 
    private_delete 
    redirect_to :back 
  end

  def populate_with_blanks
    private_populate 
    redirect_to :back
  end  

  def define_user
    if current_user.children.count >= 1
      session[:user_id] = params[:child_id] #For use in the lunch_choices controller.
      @child = current_user.children.find(params[:child_id])
    end
    return @user = current_user if current_user.admin? 
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
    
  end

  def edit
    define_user
    session[:menu_id] = params[:id]
    @menu = Menu.find(params[:id])
    @dates = @menu.lunch_date_list
  end

  def update
    @menu = Menu.find(params[:id])
    lunches = @menu.lunches 
    authorize @menu
  end

  def create
  end


  private 

  def private_delete
    @menus = Menu.all
    @menus.each do |menu|
      menu.lunches.each {|lunch| lunch.delete}
    end  
  end 


  def private_populate 
    @menus = Menu.all
    @menus.each do |menu|
      date_array = menu.date_array(2015, 7, 25)
      date_array.each do |date| 
        while menu.lunches.by_day(date).count <= 5
          menu.lunches.create(date: date, name: "edit_me")
        end 
      end
    end 
  end


end
