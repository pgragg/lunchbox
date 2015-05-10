class Menu < ActiveRecord::Base
  has_many :lunches

  def self.lunch_date_list
    dates = Array.new 
    self.lunches.each {|lunch| dates << lunch.date}
    dates.uniq! 
  end 

  def self.lunches 
    Lunch.all 
  end 

  def self.lunches_for_day(date)

    lunches_for_day = []
    lunches_for_day << self.lunches.by_day(date).load.to_a
    lunches_for_day.flatten!
  end 

end
