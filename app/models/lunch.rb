class Lunch < ActiveRecord::Base
  has_and_belongs_to_many :users, through: :lunch_choices
  belongs_to :day 

  default_scope { order('date ASC') } 
  scope :by_day, ->(date){ where(date: date)}



  def weekday
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[self.date.wday]
  end 

  def needs_decision(user)
    # lunch.date != user.lunch_choices does not contain a lunch for this date 
  end 

  def chosen_for_day?(user) 
    # does user.lunch_choices have lunch.date
    user.lunch_choices.select{|lc| lc.lunch.date = date}.any?
  end


end
