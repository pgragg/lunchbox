class Menu < ActiveRecord::Base
  has_many :days 
  has_many :lunches, through: :days 
end
