class LunchChoicesController < ApplicationController
  include ApplicationHelper

  helper :all
  
  def define_user
    if current_user.children.count >= 1
      child = current_user.children.find(session[:user_id]) #Set in the menu_controller
    end
    @user = (current_user.faculty_or_staff? ? current_user : child)
  end 
 
  def create
    define_user
    @lunch = Lunch.find(params[:lunch_id])
    @date = @lunch.date 
    @user.destroy_lunch_choices_on(@date, @lunch.lunch_type)
    lunch_choice = LunchChoice.build_choice(@lunch, @user, @date)
    if lunch_choice.save
      #
    else 
      flash[:error] = "Hmm.. try choosing a lunch that's farther ahead in the list."
    end 

    respond_to do |format|
      format.html
      format.js
    end
   end

  def update
    define_user
    @menu = Menu.find(session[:menu_id])
    @lunch_choice = LunchChoice.last
    if @lunch_choice.update_attributes(lunch_choice_params)
      
    end
    @lunch_choice.save! 

    respond_to do |format|
      format.js
      format.html 
    end
  end 
    
end


