class LunchChoicesController < ApplicationController

  
  def create
    @lunch = Lunch.find(params[:lunch_id])
    @date = @lunch.date 
    current_user.destroy_lunch_choices_on(@date) #So that we only have one lunch per day
    lunch_choice = LunchChoice.build_choice(@lunch, current_user, @date)
    if lunch_choice.save
      flash[:notice] = "You picked #{@lunch.name} for #{@lunch.weekday}"
      #redirect_to menu_index_path 
    else 
      flash[:error] = "Lunch couldn't be saved."
    end

    respond_to do |format|
      format.html
      format.js
    end
   end
end


