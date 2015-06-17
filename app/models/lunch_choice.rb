class LunchChoice < ActiveRecord::Base
  belongs_to :child
  belongs_to :user
  belongs_to :lunch

  scope :by_date, ->(date) { where(date: date)}
  scope :by_lunch_id, ->(lunch_id) { where(lunch_id: lunch_id)}
  scope :by_child_group, ->(id_array) {where(child_id: id_array)}
  scope :by_user_group, ->(id_array) {where(user_id: id_array)}


  def self.build_choice(lunch, user, date)
    user.lunch_choices.build(lunch: lunch, date: date)
  end 

  def self.count_by_date_and_grade(num, date, menu_id, grade)
    ids = Child.ids_in_grade(grade)
    lunch_id = Menu.id_by_date(num, date, menu_id)
    self.all.where("lunch_id = ?", lunch_id).by_child_group(ids).to_a.count
  end 

  def self.all_faculty_count_by_date(num, date) #Grade agnostic. Not a good idea to use. 
    output = 0
    lunch_id_1 = Menu.id_by_date(num, date, 1) #DWT fac
    lunch_id_2 = Menu.id_by_date(num, date, 3) #ECD fac
    output += self.all.where("lunch_id = ?", lunch_id_1).to_a.count
    output += self.all.where("lunch_id = ?", lunch_id_2).to_a.count
    output  #Will output totals for all faculty in ECD and DWT regardless of sp. delivery status. 
  end

  def self.all_faculty_count_by_date_and_grade(num, date, grade)
    output = 0
    ids = User.ids_in_grade(grade)
    lunch_id_1 = Menu.id_by_date(num, date, 1) #DWT fac
    lunch_id_2 = Menu.id_by_date(num, date, 3) #ECD fac
    output += self.all.by_user_group(ids).where("lunch_id = ?", lunch_id_1).to_a.count
    output += self.all.by_user_group(ids).where("lunch_id = ?", lunch_id_2).to_a.count
    output 
  end

  def self.ecd_faculty(num, date, role, grade)
    grade_ids = User.ids_in_grade(grade)
    ids = User.ids_in_role(role)
    lunch_id_2 = Menu.id_by_date(num, date, 3) #ECD fac
    self.all.by_user_group(ids).by_user_group(grade_ids).where("lunch_id = ?", lunch_id_2).to_a.count
  end

  def self.dwt_faculty(num, date)
    lunch_id_1 = Menu.id_by_date(num, date, 1) #DWT fac
    self.all.where("lunch_id = ?", lunch_id_1).to_a.count
  end


  def self.count_by_date(num, date, menu_id)
    lunch_id = Menu.id_by_date(num, date, menu_id)
    self.all.where("lunch_id = ?", lunch_id).to_a.count
  end  #Only used in the grand_totals method since it counts ALL faculty.
  

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

  def self.faculty_lunch_RH_sum(date)
    grand_total = 0 
    i = 0 
    6.times do 
      grand_total += self.all_faculty_count_by_date_and_grade(i, date, nil)
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

  def self.dwt_student_column_totals(num, date)
    grand_total = 0 
    i = 1 # We start in 1st grade at DWT school. 
    7.times do #Going down the num column, up the 7 grade levels. 
      grand_total += LunchChoice.count_by_date_and_grade(num, date, 2, i) #num, date, menu, grade. 
      i += 1
    end
    grand_total
  end 

  def self.dwt_student_RH_sum(date)
    grand_total = 0 
    i = 0 
    6.times do #Going across the 6 column totals. 
      grand_total += LunchChoice.dwt_student_column_totals(i, date)
      i += 1
    end
    grand_total
  end 
#### Experiments past this point. 
  def self.ecd_faculty_column_totals(num, date) 
    grand_total = 0
    i = 0
    3.times do 
      grand_total += self.ecd_faculty(num, @date, "faculty", i)
      i += 1
    end 
    grand_total 
  end 
  def self.ecd_faculty_RH_sum(date)
    grand_total = 0
    i = 0 
    6.times do 
      grand_total += self.ecd_faculty_column_totals(i, @date)
    end 
    grand_total 
  end 

  # def self.RH_sum(date, &block) 
  #   #num is always 0 here, since we're summing all the columns. 
  #   grand_total = 0  #Iterates through the columns, starting on 0th. 
  #   6.times do 
  #     grand_total += self.send(capture(&block(date))) 
  #     i += 1
  #   end
  #   grand_total
  # end

  # LunchChoice.RH_sum(:column_totals, 0, @date)  

 

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 

# def self.id_by_date(num, date, menu_id)
#     self.find(menu_id).lunches.by_day(date)[num].id
#   end 