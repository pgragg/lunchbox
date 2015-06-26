class Trimester < ActiveRecord::Base
  belongs_to :year 
  has_many :holidays 
end
