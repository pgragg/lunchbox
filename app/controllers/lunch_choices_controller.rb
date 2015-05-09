class LunchChoicesController < ApplicationController

  def destroy_old_choices!
    current_user.lunch_choices.each do |lc|
      lc.destroy if lc.date == @date 
    end
  end 

  def old_choices_exist
    @lunch.already_set_on_day_for(current_user)
  end 

  def create
    @lunch = Lunch.find(params[:lunch_id])
    @date = @lunch.date 
    destroy_old_choices!
     #if old_choices_exist
      # @old_choice = @lunch.already_set_on_day_for(current_user) 
      # @old_choice[0].destroy 
    lunch_choice = LunchChoice.build_choice(@lunch, current_user)
    lunch_choice.date = @date 
    #lunch_choice = current_user.lunch_choices.build(lunch: lunch)
    if lunch_choice.save
      flash[:notice] = "#{current_user.lunch_choices.uniq!{ |lc| lc.lunch.date }}"
      # flash[:notice] = "You picked #{@lunch.name} for #{@lunch.weekday}"
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


