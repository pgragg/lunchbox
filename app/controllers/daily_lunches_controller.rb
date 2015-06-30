class DailyLunchesController < ApplicationController
  def index 
    @daily_lunches = DailyLunch.all
  end 

  def new
    @daily_lunch = DailyLunch.new 
  end

  def show
    @daily_lunch = DailyLunch.find(params[:id])
  end

  def edit
    @daily_lunch = DailyLunch.find(params[:id])
  end

  def update
    @daily_lunch = DailyLunch.find(params[:id])
    if @daily_lunch.update_attributes(daily_lunch_params)
      flash[:notice] = "#{@daily_lunch.name} will be included when repopulating menus."
      redirect_to_index
    else 
      flash[:error] = "Error saving daily lunch. Please try again."
    end 
  end

  def create
    @daily_lunch = DailyLunch.new(daily_lunch_params)
    if @daily_lunch.save
     flash[:notice] = "#{@daily_lunch.name} was saved successfully."
     redirect_to_index
   else
     flash[:error] = "Error creating daily lunch. Please try again."
     render :new
   end
  end

  def destroy
    @daily_lunch = DailyLunch.find(params[:id])
    if @daily_lunch.delete
     flash[:notice] = "Deleted #{@daily_lunch.name}"
     redirect_to_index
   else
     flash[:error] = "Error deleting daily_lunch. Please try again."
   end

  end

  private 

  def redirect_to_index 
    redirect_to daily_lunches_path
  end 

  def daily_lunch_params
    params.require(:daily_lunch).permit(:name, :vegetarian, :smart, :lunch_type, :date_range)
  end
end
