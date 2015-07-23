 class MenuController < ApplicationController
  include ApplicationHelper

  def delete_all_lunches 
    private_delete 
    redirect_to :back 
  end
  # another way to do this: populate=true in URL param: if true, then call method. 

  def assign_year
    schoolyear = Year.first 
    year = schoolyear.current_trimester.end_date.year.to_i  
    month = schoolyear.current_trimester.end_date.month.to_i 
    day = schoolyear.current_trimester.end_date.day.to_i 
  end

  def populate_with_blanks
    check_for_year
    assign_year
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

  def clear_session 
    session[:user_id] = nil
    session[:child_id] = nil
  end

  def editing_child_menu
    session[:child_id] = params[:child_id] #When admin edits child lunches. 
    return @user = Child.find(params[:child_id]) 
  end

  def editing_user_menu 
    session[:user_id] = params[:id]
    return @user = User.find(params[:id])
  end

  def edit_user_or_child_menu
    clear_session
    if params[:id] && !params[:user_id] #When admin edits user lunches. 
      return editing_user_menu
    else 
      return editing_child_menu
    end
  end

  def define_user #Has two roles: define user and create session cookies. 
    case current_user.role 
      when "admin" #Admin can't currently access their OWN show page. 
        return edit_user_or_child_menu 
      when "parent"
        return editing_child_menu
      when "faculty"
        return @user = current_user
      when "staff"
        return @user = current_user 
    end
  end 


  def assign_correct_menu
      session[:menu_id] = params[:id] #not necessary, I don't think. 
      @menu = Menu.find(@user.menu_id)
    # end
    @menu 
  end

  def show
    define_user
    @menu = assign_correct_menu
    @dates = @menu.lunch_date_list
    @lunch_choice = @user.lunch_choices.last 
  end

  def edit
    @user = current_user if current_user.admin? 
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


      # if @user.class == Child
    #   @menu = Menu.find(@user.menu_id)
    # elsif current_user.admin? 
    #   if params[:format]
    #     @menu = Menu.find(params[:format])
    #     # @user = User.find(params[:id]) # So admin can order for other users. 
    #     # session[:user_id] = params[:id]
    #     session[:user_id] = nil
    #   else 
    #     @menu = Menu.find(session[:menu_id])
    #     session[:user_id] = nil
    #     # @user = current_user
    #   end
    # else 
      # @user.redirect_if_menu_id_invalid 




end
