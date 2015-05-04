class Lunch < ActiveRecord::Base
  has_and_belongs_to_many :users, through: :lunch_choices
  belongs_to :day 

  default_scope { order('date ASC') } 

  def weekday
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[self.date.wday]
  end 
end
