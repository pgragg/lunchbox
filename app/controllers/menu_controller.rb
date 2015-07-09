class MenuController < ApplicationController
  include ApplicationHelper

  def delete_all_lunches 
    private_delete 
    redirect_to :back 
  end

  def populate_with_blanks
    check_for_year
    schoolyear = Year.first 
    year = schoolyear.current_trimester.end_date.year.to_i  
    month = schoolyear.current_trimester.end_date.month.to_i 
    day = schoolyear.current_trimester.end_date.day.to_i 
    private_populate(year, month, day)
    redirect_to :back
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


  def define_user
    # return @user = current_user if current_user.admin? 
    case current_user.role 
      when "admin"
        if session[:user_id]
          return @user = User.find(session[:user_id])
        end 
        if session[:child_id]
          return @user = Child.find(session[:child_id]) 
        end
      when "parent"
        session[:user_id] = params[:child_id]
        @child = current_user.children.find(params[:child_id])
        return @user = @child 
      when "faculty"
        return @user = current_user
      when "staff"
        return @user = current_user 
    end
  end 


  def assign_correct_menu
    session[:menu_id] = params[:id]
    if @user.class == Child
      @menu = Menu.find(@user.menu_id)
    elsif current_user.admin? 
      if params[:format]
        @menu = Menu.find(params[:format])
        @user = User.find(params[:id]) # So admin can order for other users. 
        session[:user_id] = params[:id]
      else 
        @menu = Menu.find(session[:menu_id])
        @user = current_user
      end
    else 
      @user.redirect_if_menu_id_invalid 
      @menu = Menu.find(@user.menu_id)
    end
    @menu 
  end

  def show
    define_user
    @menu = assign_correct_menu
    @dates = @menu.lunch_date_list
    @lunch_choice = @user.lunch_choices.last 
  end

  def edit
    define_user
    session[:menu_id] = params[:id]
    @menu = Menu.find(params[:id])
    @dates = @menu.lunch_date_list
    authorize @menu 
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
    LunchChoice.all.each do |lc| #TODO: add a hook in lunch.rb to do this. 
      lc.delete 
    end 
  end 

  def fill_day_with_lunches(date, name, menu_id)
    menu = Menu.find(menu_id)
    lunch_count = (menu_id == 4 ? 3 : 5)
    while menu.lunches.by_day(date).count < lunch_count 
      menu.lunches.create(
        date: date, 
        name: name, 
        lunch_type: "lunch" )
    end

    fill_day_with_daily_lunches(date, menu, 'lunch')
    fill_day_with_daily_lunches(date, menu, 'drink') if (menu_id == 2 || menu_id == 4) #Drinks are only allowed for child lunches. 
  end

  def fill_day_with_daily_lunches(date, menu, type)
    DailyLunch.all.by_type(type).each do |altlunch|  # DailyLunches are templates for lunches. 
       menu.lunches.create( #This is where those templates translate into lunches. 
        date: date, 
        name: altlunch.name, 
        lunch_type: altlunch.lunch_type, 
        vegetarian: altlunch.vegetarian,
        smart: altlunch.smart)
      end
  end 

  def private_populate(year, month, day) 
    @menus = Menu.all
    date_array = @menus[0].date_array(year, month, day)
    date_array.keep_if {|date| !holiday_or_weekend?(date)}
    @menus.each do |menu|
      date_array.each do |date| 
        fill_day_with_lunches(date, "edit_me", menu.id)
      end
    end 
  end




end
