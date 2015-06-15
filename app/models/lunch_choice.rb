class LunchChoice < ActiveRecord::Base
  belongs_to :child
  belongs_to :user
  belongs_to :lunch


  def self.build_choice(lunch, user, date)
    user.lunch_choices.build(lunch: lunch, date: date)
  end 

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 