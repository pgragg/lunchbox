class LunchChoicesController < ApplicationController
  def create
    lunch = Lunch.find(params[:lunch_id])
    lunch_choice = current_user.lunch_choices.build(lunch: lunch)
    if lunch_choice.save
      flash[:notice] = "Lunch saved."
    else 
      flash[:error] = "Favorite couldn't be saved."
    end
   end

  def destroy
    lunch = Lunch.find(params[:lunch_id])
    lunch_choice = current_user.lunch_choices.find(params[:id])
    if lunch_choice.destroy 
      flash[:notice] = "No longer your lunch choice for #{lunch.weekday}"
    else 
      flash[:error] = "Couldn't change lunch choice right now."
    end 
  end
end
