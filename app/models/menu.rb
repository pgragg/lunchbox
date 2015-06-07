class Menu < ActiveRecord::Base
  has_many :lunches
  has_many :users 

  def lunch_date_list
    dates = Array.new 
    self.lunches.each {|lunch| dates << lunch.date}
    dates.uniq! 
  end 

  # def lunches
  #   Lunch.all #I'd like to filter this by lunches where the menu matches the current menu.
  # end 

  def date_array(y,m,d)
    (Date.today..Time.new(y,m,d).to_date).map{|date| date.strftime("%Y-%m-%d")}
  end 

  def date_generator(y,m,d)
    date_array(y,m,d).sample 
  end 

  # def all_in_menu
  #   all = []
  #   all << Lunch.by_menu(self.id).load.to_a 
  #   all 
  # end 

  def lunch_count
    self.lunches.count 
  end 

  def lunch_count_expected
    #5 lunches (bagels are implied as a 6th) per day for students
    #3 lunches for faculty.  
  end 



  # def lunch_for_the_day
  #   day = []
  #   (date_array(2015,06,13)).each do |d|
  #     day << Lunch.by_day(d).load.to_a
  #   end
  #   day
  # end 

  def lunches_for_day(date)

    lunches_for_day = []
    lunches_for_day << self.lunches.by_day(date).load.to_a
    lunches_for_day.flatten!
  end 

end








