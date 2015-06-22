class Summary < ActiveRecord::Base

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
                    "ecd_faculty_list"
                  when 7
                    "ecd_staff_list"
                  when 8
                    "ecd_student_list"
                  when 9 
                    "grand_totals"
    end
    "summaries/page_partials/#{suffix}"
  end 

  def self.all_menu_date_list
    output = []
    Menu.all.each do |menu| 
      output << menu.lunch_date_list
    end 
    output.uniq!.flatten!
  end 

  
end
