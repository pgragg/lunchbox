class LunchChoicesController < ApplicationController

  
  def create
    @lunch = Lunch.find(params[:lunch_id])
    @date = @lunch.date 
    current_user.destroy_lunch_choices_on(@date) #So that we only have one lunch per day
    lunch_choice = LunchChoice.build_choice(@lunch, current_user, @date)
    if lunch_choice.save
      flash[:notice] = "You picked #{@lunch.name} for #{@lunch.weekday}"
      redirect_to menu_index_path #TODO: AJAX this later. 
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


