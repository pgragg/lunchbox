class LunchesController < ApplicationController

  def new
    @lunch = Lunch.new 
  end

  def edit
    @lunch = Lunch.find(params[:id])
  end

  def update
    @lunch = Lunch.find(params[:id])
    if @lunch.update_attributes(lunch_params)
      redirect_to @menu
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

   private 

    def lunch_params
      params.require(:lunch).permit(:name, :description, :date, :vegetarian, :smart)
    end
end
