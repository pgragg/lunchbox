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
  def self.totals(num, date, menu_id_array, grade_range, role, decision=nil, lunch_type="lunch")
    output = 0  
    menu_id_array = [menu_id_array] unless menu_id_array.class == Array 
    menu_id_array.flatten.each do |single_menu_id|
      output += self.count_by_date_and_grade(num, date, single_menu_id, grade_range, role, decision=nil)
    end
    output 
  end 
# Totals 5th through adult. All fac including sp. deliveries. 
# Should count lunch totals on a date for students or fac for any given grade range, or nil grade. 
  def self.count_by_date_and_grade(num, date, menu_id, grade, role, decision=nil, lunch_type="lunch")
    
    if role.class == Array 
      output = 0 
      role.each do |individual_role|
        output += self.count_by_date_and_grade(num, date, menu_id, grade, individual_role, decision)
      end
      return output 
    end   
    lunch = Menu.lunch_by_date(num, date, menu_id)
    if lunch 
      lunch_id = lunch.id 
    end
    user_group = []
    if role == "students"
      ids = Child.ids_in_grade(grade)
      user_group << ids 
      return self.by_child_group(user_group).where("lunch_id = ?", lunch_id).to_a.count
    elsif role == "faculty"
      grade_ids = User.ids_in_grade(grade) 
      faculty_ids = User.ids_in_role(role)
      #Faculty ids will be used only if they belong to a certain grade. 
      #nil for non-sp. deliv. [grade] for sp. deliv. [[grade],nil].flatten for both
      faculty_ids.keep_if {|id| grade_ids.include? id }
      user_group << faculty_ids
    elsif role == "staff"
      staff_ids = User.ids_in_role(role)
      user_group << staff_ids
    end 

    self.by_user_group(user_group.flatten).where("lunch_id = ?", lunch_id).to_a.count
  end 

  # def self.count_by_date(num, date, menu_id)
  #   lunch_id = Menu.id_by_date(num, date, menu_id)
  #   self.all.where("lunch_id = ?", lunch_id).to_a.count
  # end  
  #Can also be used in the grand_totals method 
  #since it counts ALL DWT or ECD faculty regardless of grade-level delivery.
  def self.column_totals(num, date, menu_id, grade_range, role) 
    if role == "grand"
      grand_total = 0 
      grand_total += self.column_totals(num,date,Menu.id_for(grade_range,"faculty"),grade_range, "faculty")
      grand_total += self.column_totals(num,date,Menu.id_for(grade_range,"students"),grade_range, "students")
      return grand_total
    end 
    grand_total = 0 
    i = 0  
    number_of_rows = (grade_range.class == Array ? grade_range.count : 1)
    number_of_rows.times do #Going down the num column, up the (number of rows) grade levels. 
      grade = (grade_range.class == Array ? grade_range[i] : grade_range) 
      grand_total += LunchChoice.count_by_date_and_grade(num, date, menu_id, grade, role) #num, date, menu, grade. 
      i += 1
    end
    grand_total
  end 

  def self.big_lunch_totals(num, date) #Totals 5th through adult. All fac including sp. deliveries. 
    big_lunches = 0
    big_lunches += self.totals(num, date, 1, [nil, Child::DWT_GRADES], "faculty") # faculty including sp. deliveries
    big_lunches += self.totals(num, date, 2, [5,6,7], "students") #stud 5-7
    big_lunches
  end

  def self.agnostic_column_totals(num, date)
    all_lunches = 0 
    all_lunches += self.big_lunch_totals(num, date) #Totals 5th through adult 
    all_lunches += self.totals(num, date, 2, [1,2,3,4], "students") #Totals 1-4th grade 
    all_lunches += self.totals(num, date, 4, Child::ECD_GRADES, "students") #Totals ECD grades 
    all_lunches
  end 

  def self.RH_sum(date, menu_id, grade_range, role, number_of_columns)
    grand_total = 0 
    i = 0 
    number_of_columns.times do #Going across the 6 column totals. 
      grand_total += LunchChoice.column_totals(i, date, menu_id, grade_range, role)
      i += 1
    end
    grand_total
  end 

  def self.sum(amount, date, menu_id = nil, grade_range = nil, role = nil)
    sum = 0 
    i = 0  
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

## ## ## ## ## ## ## Faculty ## ## ## ## ## ## ## ## 

  # def self.faculty_lunch_RH_sum(date, decision)
  #   grand_total = 0 
  #   i = 0 
  #   6.times do 
  #     grand_total += self.all_faculty_count_by_date_and_grade(i, date, nil, decision)
  #     i += 1
  #   end
  #   grand_total
  # end

  # def self.all_faculty_count_by_date(num, date) #Grade agnostic. 
  #   output = 0
  #   dwt_lunch_id = Menu.id_by_date(num, date, 1) #DWT fac
  #   ecd_lunch_id = Menu.id_by_date(num, date, 3) #ECD fac
  #   output += self.all.where("lunch_id = ?", dwt_lunch_id).to_a.count
  #   output += self.all.where("lunch_id = ?", ecd_lunch_id).to_a.count
  #   output  #Will output totals for all faculty in ECD and DWT regardless of sp. delivery status. 
  # end

 

  # def self.dwt_adult(num, date, role, grade)
  #   grade_ids = User.ids_in_grade(grade)
  #   ids = User.ids_in_role(role)
  #   dwt_lunch_id = Menu.id_by_date(num, date, 1) #DWT fac
  #   self.all.by_user_group(ids).by_user_group(grade_ids).where("lunch_id = ?", dwt_lunch_id).to_a.count
  # end

  # ## ## ## ## ## ## ## ECD Faculty ## ## ## ## ## ## ## ## 

  # def self.ecd_adult(num, date, role, grade)
  #   grade_ids = User.ids_in_grade(grade)
  #   ids = User.ids_in_role(role)
  #   ecd_lunch_id = Menu.id_by_date(num, date, 3) #ECD fac
  #   self.all.by_user_group(ids).by_user_group(grade_ids).where("lunch_id = ?", ecd_lunch_id).to_a.count
  # end

  # def self.ecd_adult_column_totals(num, date, role, grade_range) 
  #   grand_total = 0
  #   i = 0
  #   number_of_rows = grade_range.count
  #   number_of_rows.times do 
  #     grade = grade_range[i]
  #     grand_total += self.ecd_adult(num, date, role, grade_range[i])
  #     i += 1
  #   end 
  #   grand_total 
  # end 

  # def self.ecd_adult_RH_sum(date, role, grade_range)
  #   grand_total = 0
  #   i = 0 
  #   6.times do 
  #     grand_total += self.ecd_adult_column_totals(i, date, role, grade_range)
  #     i += 1 
  #   end 
  #   grand_total 
  # end 


  #   ## ## ## ## ## ## ## Grand Totals Page ## ## ## ## ## ## ## ## 


  #   #   stud_lunch_id = Menu.id_by_date(num, date, 2)
  #   # fac_lunch_id = Menu.id_by_date(num, date, 1)

 
  # def self.big_lunch_RH_sum(date)
  #   grand_total = 0 
  #   i = 0 
  #   6.times do 
  #     grand_total += self.big_lunch_totals(i, date)
  #     i += 1
  #   end
  #   grand_total
  # end


   

  # def self.faculty_and_students_by_date_and_grade(num, date, grade) 
  #   output = 0
  #   faculty_ids = User.ids_in_grade(grade)  
  #   faculty_menu_id = Menu.id_for(grade, "faculty") 
  #   faculty_lunch_id =  Menu.id_by_date(num, date, faculty_menu_id)
  #   output += self.all.by_user_group(faculty_ids).where("lunch_id = ?", faculty_lunch_id).to_a.count
  #   output += LunchChoice.count_by_date_and_grade(num, date, (Menu.id_for(grade, "students")), grade)
  #   output 
  # end

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 

# def self.id_by_date(num, date, menu_id)
#     self.find(menu_id).lunches.by_day(date)[num].id
#   end 