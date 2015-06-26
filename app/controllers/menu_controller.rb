class MenuController < ApplicationController
  include ApplicationHelper

  def delete_all_lunches 
    private_delete 
    redirect_to :back 
  end

  def populate_with_blanks
    schoolyear = Year.first 
    year = schoolyear.current_trimester.end_date.year.to_i  
    month = schoolyear.current_trimester.end_date.month.to_i 
    day = schoolyear.current_trimester.end_date.day.to_i 
    private_populate(year, month, day)
    redirect_to :back
  end  

  def define_user
    if current_user.children.count >= 1
      session[:user_id] = params[:child_id] #For use in the lunch_choices controller.
      @child = current_user.children.find(params[:child_id])
    end
    return @user = current_user if current_user.admin? 
    @user = (current_user.faculty_or_staff? ? current_user : @child)
  end 

  def index
    @menus = Menu.all
    define_user
    authorize @menus
  end
  
  def new
    @menu = Menu.new
    authorize @menu
  end

  def assign_correct_menu
    if @user.class == Child
      @menu = Menu.find(@user.menu_id)
    elsif @user.role == "admin"
      @menu = Menu.find(params[:id])
    else 
      @user.redirect_if_menu_id_invalid 
      @menu = Menu.find(@user.menu_id)
    end
    @menu 
  end

  def show
    define_user
    assign_correct_menu
    @dates = @menu.lunch_date_list
    @lunch_choice = @user.lunch_choices.last 
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

  # include ApplicationHelper

  def private_delete
    Lunch.all.each do |lunch| 
      lunch.delete 
    end  
  end 

  def fill_day_with_lunches(date, name, menu_id)
    menu = Menu.find(menu_id)
    lunch_count = (menu_id == 4 ? 3 : 5)
    while menu.lunches.by_day(date).count < lunch_count 
      menu.lunches.create(date: date, name: name)
    end

    menu.bagels.create(date: date, name: "Bagel")
  end

  def private_populate(y, m, d) 
    @menus = Menu.all
    date_array = @menus[0].date_array(y, m, d)
    date_array.keep_if {|date| !holiday_or_weekend?(DateTime.parse(date)) }
    @menus.each do |menu|
      date_array.each do |date| 
        fill_day_with_lunches(date, "edit_me", menu.id)
      end
    end 
  end




end
