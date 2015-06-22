class Menu < ActiveRecord::Base
  has_many :lunches
  has_many :children 
  has_many :users

  def self.lunch_by_date(num, date, menu_id)
    self.find(menu_id).lunches.by_day(date)[num]
  end 
  def self.id_by_date(num, date, menu_id)
    lunch = self.lunch_by_date(num, date, menu_id)
    if lunch
      return lunch.id 
    else 
      nil
    end
  end 

  def self.id_for(grade, role)
    campus = "DWT"
    campus = "ECD" if Child::ECD_GRADES.include?(grade)
    case role 
          when "students"
          output = (campus == "ECD" ? 4 : 2)
          when "faculty"
          output = (campus == "ECD" ? 3 : 1)
    end 
    output 
  end 

  def self.lunch_name_on(num, date, menu_id) #This method exists because it protects the output against nil. 
    lunch = self.lunch_by_date(num, date, menu_id)
    if lunch 
      return lunch.name
    end 
  end 

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

  def lunches_for_day(date)

    lunches_for_day = []
    lunches_for_day << self.lunches.by_day(date).load.to_a
    lunches_for_day.flatten!
  end 

end








