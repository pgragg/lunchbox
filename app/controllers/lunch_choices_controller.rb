class LunchChoicesController < ApplicationController

  # def define_user

  #   @children = current_user.children
  #   puts "Current children are #{@children}"
  #   if @children.count >= 1
  #     paramet = params[:child_id]
  #     puts "Getting ready to define child with #{paramet}"
  #     @child = @children.find(params[:child_id]) #:child_id is nil here because it's not defined in lunch_choice params. 
  #     puts "Child is @child"
  #   end
  #   @user = (current_user.role == "faculty" ? current_user : @child)
  # end 

  
  def create
    puts "#{@user} is your currently defined user."
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


