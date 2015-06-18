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
                    "grand_totals"
    end
    "summaries/page_partials/#{suffix}"
  end 

  
end
