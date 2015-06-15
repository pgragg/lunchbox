class Summary < ActiveRecord::Base

  def summary_partial_for(id)
    case id 
         when 1, 2, 3, 4
          "summary"
         else 
          "grand_totals"
    end
  end 
end
