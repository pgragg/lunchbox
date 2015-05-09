class LunchChoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :lunch


  def self.build_choice(lunch, current_user)
    current_user.lunch_choices.build(lunch: lunch)
  end 

  def self.chosen_for_day?(user) 
  # does user.lunch_choices have lunch.date
    user.lunch_choices.select{|lc| lc.lunch.date = @lunch.date}.any?
  end

  def self.will_delete
    choice.destroy
    redirect_to menu_index_path
  end 

   

  

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 