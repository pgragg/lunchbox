class LunchChoice < ActiveRecord::Base
  belongs_to :child
  belongs_to :user
  belongs_to :lunch

  scope :by_date, ->(date) { where(date: date)}
  scope :by_lunch_id, ->(lunch_id) { where(lunch_id: lunch_id)}
  scope :by_child_group, ->(id_array) {where(child_id: id_array)}
  scope :by_user_group, ->(id_array) {where(user_id: id_array)}


  #num stands for "lunch number." It's a way to reference which lunch we're referring to. 


  def self.build_choice(lunch, user, date)
    user.lunch_choices.build(lunch: lunch, date: date)
  end 

  ## ## ## ## ## ## ## Students ## ## ## ## ## ## ## ## 

  def self.count_by_date_and_grade(num, date, menu_id, grade)
    ids = Child.ids_in_grade(grade)
    lunch_id = Menu.lunch_by_date(num, date, menu_id).id
    self.by_child_group(ids).where("lunch_id = ?", lunch_id).to_a.count
  end 

  def self.count_by_date(num, date, menu_id)
    lunch_id = Menu.id_by_date(num, date, menu_id)
    self.all.where("lunch_id = ?", lunch_id).to_a.count
  end  
  #Can also be used in the grand_totals method 
  #since it counts ALL DWT or ECD faculty regardless of grade-level delivery. 

  def self.student_column_totals(num, date, menu_id, grade_range) 
    grand_total = 0 
    i = 0 # We start in 1st grade at DWT Campus. 
    number_of_rows = grade_range.count 
    number_of_rows.times do #Going down the num column, up the (number of rows) grade levels. 
      grade = grade_range[i]
      grand_total += LunchChoice.count_by_date_and_grade(num, date, menu_id, grade) #num, date, menu, grade. 
      i += 1
    end
    grand_total
  end 

  def self.student_RH_sum(date, menu_id, grade_range, number_of_columns)
    grand_total = 0 
    i = 0 
    number_of_columns.times do #Going across the 6 column totals. 
      grand_total += LunchChoice.student_column_totals(i, date, menu_id, grade_range)
      i += 1
    end
    grand_total
  end 

## ## ## ## ## ## ## Faculty ## ## ## ## ## ## ## ## 

  def self.faculty_lunch_RH_sum(date, decision)
    grand_total = 0 
    i = 0 
    6.times do 
      grand_total += self.all_faculty_count_by_date_and_grade(i, date, nil, decision)
      i += 1
    end
    grand_total
  end

  def self.all_faculty_count_by_date(num, date) #Grade agnostic. 
    output = 0
    dwt_lunch_id = Menu.id_by_date(num, date, 1) #DWT fac
    ecd_lunch_id = Menu.id_by_date(num, date, 3) #ECD fac
    output += self.all.where("lunch_id = ?", dwt_lunch_id).to_a.count
    output += self.all.where("lunch_id = ?", ecd_lunch_id).to_a.count
    output  #Will output totals for all faculty in ECD and DWT regardless of sp. delivery status. 
  end

  def self.all_faculty_count_by_date_and_grade(num, date, grade, decision = nil) 
    exclude_fac = true if decision == "exclude_ecd_teachers"
    output = 0
    #Use nil for grade if not sp. delivery.
    ids = User.ids_in_grade(grade)  
    #We find ids for either faculty AND staff, or just staff
    user_ids = (exclude_fac ?  User.ids_in_role("staff") : User.ids_in_role(["staff", "faculty"])) 
    dwt_lunch_id = Menu.id_by_date(num, date, 1) #DWT fac
    ecd_lunch_id = Menu.id_by_date(num, date, 3) #ECD fac
    output += self.all.by_user_group(ids).where("lunch_id = ?", dwt_lunch_id).to_a.count
    output += self.all.by_user_group(user_ids).by_user_group(ids).where("lunch_id = ?", ecd_lunch_id).to_a.count
    output 
  end

  def self.dwt_adult(num, date, role, grade)
    grade_ids = User.ids_in_grade(grade)
    ids = User.ids_in_role(role)
    dwt_lunch_id = Menu.id_by_date(num, date, 1) #DWT fac
    self.all.by_user_group(ids).by_user_group(grade_ids).where("lunch_id = ?", dwt_lunch_id).to_a.count
  end

  ## ## ## ## ## ## ## ECD Faculty ## ## ## ## ## ## ## ## 

  def self.ecd_adult(num, date, role, grade)
    grade_ids = User.ids_in_grade(grade)
    ids = User.ids_in_role(role)
    ecd_lunch_id = Menu.id_by_date(num, date, 3) #ECD fac
    self.all.by_user_group(ids).by_user_group(grade_ids).where("lunch_id = ?", ecd_lunch_id).to_a.count
  end

  def self.ecd_adult_column_totals(num, date, role, grade_range) 
    grand_total = 0
    i = 0
    number_of_rows = grade_range.count
    number_of_rows.times do 
      grade = grade_range[i]
      grand_total += self.ecd_adult(num, date, role, grade_range[i])
      i += 1
    end 
    grand_total 
  end 

  def self.ecd_adult_RH_sum(date, role, grade_range)
    grand_total = 0
    i = 0 
    6.times do 
      grand_total += self.ecd_adult_column_totals(i, date, role, grade_range)
      i += 1 
    end 
    grand_total 
  end 


    ## ## ## ## ## ## ## Grand Totals Page ## ## ## ## ## ## ## ## 

  def self.big_lunch_totals(num, date) #Totals 5th through adult 
    big_lunches = 0
    stud_lunch_id = Menu.id_by_date(num, date, 2)
    big_lunches += self.all_faculty_count_by_date(num, date) # faculty including sp. deliveries
    big_lunches += self.count_by_date_and_grade(num, date, 2, [5,6,7]) #stud 5-7
    big_lunches
  end

 
  def self.big_lunch_RH_sum(date)
    grand_total = 0 
    i = 0 
    6.times do 
      grand_total += self.big_lunch_totals(i, date)
      i += 1
    end
    grand_total
  end


   def self.column_totals(num, date)
    all_lunches = 0 
    all_lunches += self.big_lunch_totals(num, date) #Totals 5th through adult 
    all_lunches += self.count_by_date_and_grade(num, date, 2, [1,2,3,4]) #Totals 1-4th grade 
    all_lunches += self.count_by_date(num, date, 4) #Totals ECD grades 
    all_lunches
  end 

  def self.faculty_and_students_by_date_and_grade(num, date, grade) 
    output = 0
    faculty_ids = User.ids_in_grade(grade)  
    faculty_menu_id = Menu.id_for(grade, "Teachers") 
    faculty_lunch_id =  Menu.id_by_date(num, date, faculty_menu_id)
    output += self.all.by_user_group(faculty_ids).where("lunch_id = ?", faculty_lunch_id).to_a.count
    output += LunchChoice.count_by_date_and_grade(num, date, (Menu.id_for(grade, "Students")), grade)
    output 
  end

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 

# def self.id_by_date(num, date, menu_id)
#     self.find(menu_id).lunches.by_day(date)[num].id
#   end 