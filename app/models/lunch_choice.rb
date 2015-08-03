class LunchChoice < ActiveRecord::Base
  belongs_to :child
  belongs_to :user
  belongs_to :lunch

  scope :by_date, ->(date) { where(date: date)}
  scope :by_lunch_id, ->(lunch_id) { where(lunch_id: lunch_id)}
  scope :by_child_group, ->(id_array) {where(child_id: id_array)}
  scope :by_user_group, ->(id_array) {where(user_id: id_array)}
  scope :eager,  -> { includes(:lunch) }  


  #num stands for "lunch number." It's a way to reference which lunch we're referring to. 


  def self.build_choice(lunch, user, date)
    user.lunch_choices.build(lunch: lunch, date: date)
  end 

  ## ## ## ## ## ## ## Students ## ## ## ## ## ## ## ## 
  def self.totals(num, date, menu_id_array, grade_range, role, decision=nil)
    output = 0  
    menu_id_array = [menu_id_array] unless menu_id_array.class == Array 
    menu_id_array.flatten.each do |single_menu_id|
      output += self.count_by_date_and_grade(num, date, single_menu_id, grade_range, role, decision=nil)
    end
    output 
  end 
# Totals 5th through adult. All fac including sp. deliveries. 
# Should count lunch totals on a date for students or fac for any given grade range, or nil grade.

  #Translate_i takes menu numbers from menu 2 and finds corresponding menu numbers in menu 4. 
  def self.translate_i(i, menu_id)
    if menu_id == 4 
      case true 
      when [0,1,2].include?(i)
        return i 
      when [3,4].include?(i)
        return nil
      when [5,6,7,8,9,10,11].include?(i)
        return (i-2) #Corrects for missing lunches (3 and 4) in ECD menu. 
      else 
        return i 
      end 
    else 
      return i 
    end 
  end 

  def self.count_by_date_and_grade(num, date, menu_id, grade, role, decision=nil)
    
    if role.class == Array 
      output = 0 
      role.each do |individual_role|
        output += self.count_by_date_and_grade(num, date, menu_id, grade, individual_role, decision)
      end
      return output 
    end   

    lunch = Menu.lunch_by_date(num, date, menu_id)
    # lunch = Menu.find(menu_id).lunches.by_day(date)[num]
    if lunch
      lunch_id = lunch.id 
    end
    user_group = []
    
    if role == "students"
      ids = Child.ids_in_grade(grade)
      user_group << ids 
      return self.by_child_group(user_group).where("lunch_id = ?", lunch_id).to_a.count
    else
      grade_ids = User.ids_in_grade(grade) 
      adult_ids = User.ids_in_role(role)
      #Faculty ids will be used only if they belong to a certain grade. 
      #nil for non-sp. deliv. [grade] for sp. deliv. [[grade],nil].flatten for both
      adult_ids.keep_if {|id| grade_ids.include? id }
      user_group << adult_ids
    end 

    self.by_user_group(user_group.flatten).where("lunch_id = ?", lunch_id).to_a.count
  end 

  def self.column_totals(num, date, menu_id, grade_range, role, type="lunch") 
    if role == "grand"
      grand_total = 0 
      grand_total += self.column_totals(num,date,Menu.id_for(grade_range,"faculty"),grade_range, "faculty", type)
      grand_total += self.column_totals(num,date,Menu.id_for(grade_range,"students"),grade_range, "students", type)
      return grand_total
    end 
    grand_total = 0 
    i = 0  
    number_of_rows = (grade_range.class == Array ? grade_range.count : 1)
    number_of_rows.times do #Going down the num column, up the (number of rows) grade levels. 
      grade = (grade_range.class == Array ? grade_range[i] : grade_range) 
      grand_total += LunchChoice.count_by_date_and_grade(num, date, menu_id, grade, role, type) #num, date, menu, grade. 
      i += 1
    end
    grand_total
  end 

  def self.big_lunch_totals(num, date) #Totals 5th through adult. All fac including sp. deliveries. 
    big_lunches = 0
    big_lunches += self.totals(num, date, [1,3], [nil,"", Child::GRADES], ["faculty","staff"]) # faculty including sp. deliveries
    big_lunches += self.totals(num, date, 2, [5,6,7], "students") #stud 5-7
    big_lunches
  end

  def self.agnostic_column_totals(num, date)
    all_lunches = 0 
    all_lunches += self.big_lunch_totals(num, date) #Totals 5th through adult 
    all_lunches += self.totals(num, date, 2, [1,2,3,4], "students") #Totals 1-4th grade 
    all_lunches += self.totals(self.translate_i(num, 4), date, 4, Child::ECD_GRADES, "students") #Totals ECD grades 
    all_lunches
  end 

  def self.RH_sum(date, menu_id, grade_range, role, number_of_columns, type="lunch")
    grand_total = 0 
    i = 0 
    number_of_columns -= 3 if (menu_id == 2 || menu_id == 4) 
    number_of_columns.times do #Going across the 6 column totals. 
      grand_total += LunchChoice.column_totals(i, date, menu_id, grade_range, role, type)
      i += 1
    end
    grand_total
  end 

  def self.sum(amount, date, menu_id = nil, grade_range = nil, role = nil)
    sum = 0 
    i = 0  
    amount -= 5 if menu_id == 4 
    amount -= 3 if menu_id == 2
    amount.times do 
      sum += yield(i,date, menu_id, grade_range, role) if block_given?
      i += 1 
    end
    sum 
  end

   def self.all_faculty_count_by_date_and_grade(num, date, grade, decision = nil) 
    exclude_fac = true if decision == "exclude_ecd_teachers"
    user_ids = (exclude_fac ?  User.ids_in_role("staff") : User.ids_in_role(["staff", "faculty"])) 
    output = 0
    #Use nil for grade if not sp. delivery.
    ids = User.ids_in_grade(grade)  
    #We find ids for either faculty AND staff, or just staff
    
    dwt_lunch_id = Menu.id_by_date(num, date, 1) #DWT fac
    ecd_lunch_id = Menu.id_by_date(num, date, 3) #ECD fac
    output += self.all.by_user_group(ids).where("lunch_id = ?", dwt_lunch_id).to_a.count
    output += self.all.by_user_group(user_ids).by_user_group(ids).where("lunch_id = ?", ecd_lunch_id).to_a.count
    output 
  end

  private 

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 

# def self.id_by_date(num, date, menu_id)
#     self.find(menu_id).lunches.by_day(date)[num].id
#   end 