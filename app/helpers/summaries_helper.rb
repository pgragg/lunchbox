module SummariesHelper
  def row_marker(user, date, n )
    i = 0 
    n.times do 
      content_tag(:td, user.choice_for?(date, i))
      i += 1 
    end 
  end 

  def render_appropriate_cells(date, grade, type)

    i = 0 
    output = ""
    6.times do 

      tcell = content_tag :td do 
        case type 
          when "Students"
            LunchChoice.count_by_date_and_grade(i, date, (Menu.id_for(grade, type)), grade)
          when "Teachers"
            LunchChoice.all_faculty_count_by_date_and_grade(i, date, grade, decision = nil)
          when "Staff"
            LunchChoice.all_faculty_count_by_date_and_grade(i, date, grade, decision = nil)
            #something else needs to go here.
          else 
            LunchChoice.faculty_and_students_by_date_and_grade(i, date, grade)
        end 
        output << tcell.to_s.html_safe

      end 
    i += 1
    end 

  content_tag :table, output.html_safe
  end 


end 


# def display_standard_table(columns, collection = {})

#  tbody = content_tag :tbody do
#   collection.collect { |elem|
#     content_tag :tr do
#       columns.collect { |column|
#           concat content_tag(:td, elem.attributes[column[:name]])
#       }.to_s.html_safe
#     end

#   }.join().html_safe
#  end

#  content_tag :table, thead.concat(tbody)

# end