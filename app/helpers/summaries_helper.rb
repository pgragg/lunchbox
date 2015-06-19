module SummariesHelper
  def row_marker(user, date, n )
    i = 0 
    n.times do 
      content_tag(:td, user.choice_for?(date, i))
      i += 1 
    end 
  end 
end 

