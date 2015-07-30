class Menu < ActiveRecord::Base
  has_many :lunches, dependent: :destroy 
  has_many :children 
  has_many :users

  def self.menu_translated(num, menu_id) #NEW
    #If the menu in question is ECD, it's limited. 
    #5, 6, 7, 8 correspond to bagel choices on every menu but ECD. 
    #This function fixes that. 
    if menu_id == 4 
      case num 
      when [3..4] #ECD menu doesn't have 3rd or 4th lunch options, so 
        num += 7
      when [5..11]
        num -= 2 
      end
    end 
  end

  def self.lunch_by_date(num, date, menu_id)
    num = self.menu_translated(num, menu_id) #NEW
    self.find(menu_id).lunches.by_day(date)[num]
  end 
  
  def self.id_by_date(num, date, menu_id)
    num = self.menu_translated(num, menu_id) #NEW
    lunch = self.lunch_by_date(num, date, menu_id)
    if lunch
      return lunch.id 
    else 
      nil
    end
  end 

  def self.id_for(grade, role, campus="DWT")
    if grade #Staff and most faculty don't have grades. 
      grade = grade[0] #In case grade is entered as an array. 
    end 
    campus = "ECD" if Child::ECD_GRADES.include?(grade)
    case role 
          when "students"
          output = (campus == "ECD" ? 4 : 2)
          when ("faculty")
          output = (campus == "ECD" ? 3 : 1)
          when ("staff")
          output = (campus == "ECD" ? 3 : 1)
    end 
    output 
  end 

  def self.lunch_name_on(num, date, menu_id) #This method exists because it protects the output against nil. 
    num = self.menu_translated(num, menu_id) #NEW
    lunch = self.lunch_by_date(num, date, menu_id)
    if lunch 
      return lunch.name
    end 
  end 

  def lunch_date_list
    dates = Array.new 
    self.lunches.each {|lunch| dates << lunch.date}
    dates.uniq! 
    dates 
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

  # def date_generator(y,m,d)
  #   date_array(y,m,d).sample 
  # end 

  def lunch_count
    self.lunches.count 
  end 

  def lunches_for_day(date)

    lunches_for_day = []
    lunches_for_day << self.lunches.by_day(date).load.to_a
    lunches_for_day.flatten!
  end 

end








