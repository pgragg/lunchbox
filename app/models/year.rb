class Year < ActiveRecord::Base
  has_many :trimesters 

  def current_trimester
    if self.trimesters.where("start_date <= ?", Date.today).count >= 1 
      self.trimesters.where("start_date <= ?", Date.today).where("end_date >= ?", Date.today).first 
    else 
      self.trimesters.where("number = ?", 1).first 
      #If we're in the midst of summer and have deleted all trimesters, 
      #We'll treat the "current_trimester" as the first trimester of the school year.
      #This method should only be called if we don't have a currently defined trimester. 
      #Which is rarely: really only during summers.  
    end
  end
end
