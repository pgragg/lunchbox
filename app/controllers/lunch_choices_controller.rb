class LunchChoicesController < ApplicationController

  def define_user
    if current_user.children.count >= 1
      child = current_user.children.find(session[:user_id]) #Set in the menu_controller
    end
    @user = (current_user.role == "faculty" ? current_user : child)
  end 
 
  def create
    define_user
    @lunch = Lunch.find(params[:lunch_id])
    @date = @lunch.date 
    @user.destroy_lunch_choices_on(@date) #So that we only have one lunch per day
    lunch_choice = LunchChoice.build_choice(@lunch, @user, @date)
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


