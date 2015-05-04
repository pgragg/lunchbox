class Day < ActiveRecord::Base
  has_many :lunches 
  has_many :lunch_choices 
end
