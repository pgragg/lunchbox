module SummariesHelper
  def row_marker(user, date, n )
    i = 0 
    n.times do 
      content_tag(:td, user.choice_for?(date, i))
      i += 1 
    end 
  end 

  def display_all(collection)
    collection.collect {|value| 
      content_tag(:td, value.to_s.html_safe)}
    collection.to_s.html_safe
  end

  def render_appropriate_cells(date, grade, role)
    i = 0 
    output = []
    6.times do 
        if role == "grand"
          #Do Grand thing 
        else #Role here is "students" or "faculty"
          output << LunchChoice.column_totals(i, date, Menu.id_for(grade, role), grade, role)
        end 
    i += 1
    end 
     
  display_all(output)
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