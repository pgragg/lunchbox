class Summary < ActiveRecord::Base
  
  default_scope { order('id ASC') } 

  def summary_partial_for(id)
    suffix = case id 
                  when 1
                    "all_faculty"
                  when 2 
                    "dwight_students"
                  when 3
                    "ecd_faculty"
                  when 4
                    "ecd_students"
                  when 5
                    "dwight_students_and_teachers_list"
                  when 6
                    "dwight_staff_list" #Scholastic calls them "Dwight Faculty"
                  when 7
                    "ecd_faculty_list"
                  when 8
                    "ecd_staff_list"
                  when 9
                    "ecd_student_list"
                  when 10 
                    "grand_totals"
    end
    "summaries/page_partials/#{suffix}"
  end 

  def name_by_id
    suffix = case self.id 
                  when 1
                    "All Teachers"
                  when 2 
                    "Dwt Students"
                  when 3
                    "Ecd Teachers"
                  when 4 
                    "Ecd Students"
                  when 5 
                    "Dwt Students + Teachers List"
                  when 6 
                    "Dwt Staff List" #Scholastic calls them "Dwight Faculty"
                  when 7
                    "Ecd Teachers List"
                  when 8
                    "Ecd Staff List"
                  when 9
                    "Ecd Student List"
                  when 10 
                    "Grand Totals"
    end
    suffix
  end 

  def lunches
    lunches = 12 
    lunches = 10 if (self.id == 9 || self.id == 6) #ECD student list ID 
    lunches 
  end

  def self.all_menu_date_list
    output = []
    Menu.all.each do |menu| 
      output << menu.lunch_date_list
    end 
    output.uniq!.flatten!
  end 

  
end
