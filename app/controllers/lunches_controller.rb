class LunchesController < ApplicationController
  include LunchesHelper

  def standardize_menus(lunches, date)
    params= []
    lunches.by_day(date).each do |lunch| 
      params << [lunch.name, lunch.vegetarian, lunch.smart] 
    end 
    Menu.all.each do |menu|
      menu.lunches.by_day(date).each_with_index do |lunch,i| 
        if params[i] 
          unless safe(params[i][0]) == false
            lunch.update_attributes(name: params[i][0]) 
            lunch.update_attributes(vegetarian: params[i][1], smart: params[i][2]) 
          end 
        end
        
      end 
      menu.save!
    end
  end 

  def safe(name) 
    name != nil
  end 

  def new
    @lunch = Lunch.new 
  end

  def show
    @lunch = Lunch.find(params[:id])
  end

  def edit
    @lunch = Lunch.find(params[:id])
  end

  def update
    @menu = Menu.find(session[:menu_id])
    @lunch = Lunch.find(params[:id])
    if @lunch.update_attributes(lunch_params)
      standardize_menus(@menu.lunches, @lunch.date)
      redirect_to edit_menu_path(@menu)
    else 
      flash[:error] = "Error saving lunch. Please try again."
    end 
  end

  def create
    @menu = Menu.find(params[:id])
    @lunch = Lunch.new(lunch_params)
    if @lunch.save
     redirect_to @menu, notice: "Lunch was saved successfully."
   else
     flash[:error] = "Error creating lunch. Please try again."
     render :new
   end

  end

  def destroy
    @menu = Menu.find(session[:menu_id])
    @lunch = Lunch.find(params[:id])
    if @lunch.delete
     redirect_to edit_menu_path(@menu), notice: "Deleted #{@lunch.name}"
   else
     flash[:error] = "Error deleting lunch. Please try again."
     redirect_to edit_menu_path(@menu)
   end

  end

   private 

    def lunch_params
      params.require(:lunch).permit(:name, :description, :date, :vegetarian, :smart)
    end
end
