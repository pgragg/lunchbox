class LunchChoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :day
  belongs_to :lunch
end


#lunch choice is a way to reference the given lunches for any user, or for any day. 