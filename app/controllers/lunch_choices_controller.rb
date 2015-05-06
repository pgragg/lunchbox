class LunchChoicesController < ApplicationController
  def create
    lunch = Lunch.find(params[:lunch_id])
    lunch_choice = LunchChoice.build_choice(lunch, current_user)
    #lunch_choice = current_user.lunch_choices.build(lunch: lunch)
    if lunch_choice.save
      flash[:notice] = "You picked #{lunch.name} for #{lunch.weekday}"
      redirect_to menu_index_path
    else 
      flash[:error] = "Lunch couldn't be saved."
    end
   end

  def destroy
    lunch = Lunch.find(params[:lunch_id])
    lunch_choice = current_user.lunch_choices.find(params[:id])
    if lunch_choice.destroy 
      flash[:notice] = "#{lunch.name} is no longer your lunch choice for #{lunch.weekday}"
      redirect_to menu_index_path
    else 
      flash[:error] = "Couldn't change lunch choice right now."
    end 
  end
end


