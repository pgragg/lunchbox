class Menu < ActiveRecord::Base
  has_many :lunches
  has_many :children 
  has_many :users

  def lunch_date_list
    dates = Array.new 
    self.lunches.each {|lunch| dates << lunch.date}
    dates.uniq! 
  end 

  def self.master_date_list
    dates = Array.new 
    self.all.each do |menu|  
      menu.lunches.each {|lunch| dates << lunch.date}
    end 
    dates.sort.uniq! 
  end 

  def users_count
    self.children.count + self.users.count 
  end 

  def lunches_count
    self.lunches.count
  end 

  def date_array(y,m,d)
    (Date.today..Time.new(y,m,d).to_date).map{|date| date.strftime("%Y-%m-%d")}
  end 

  def date_generator(y,m,d)
    date_array(y,m,d).sample 
  end 

  def lunch_count
    self.lunches.count 
  end 

  def lunch_count_expected
    #5 lunches (bagels are implied as a 6th) per day for students
    #3 lunches for faculty.  
  end 

  def lunches_for_day(date)

    lunches_for_day = []
    lunches_for_day << self.lunches.by_day(date).load.to_a
    lunches_for_day.flatten!
  end 

end








