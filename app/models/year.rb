class Year < ActiveRecord::Base
  has_many :trimesters 

  def current_trimester
    if self.trimesters.where("start_date <= ?", Date.today).count >= 1 
      self.trimesters.where("start_date <= ?", Date.today).where("end_date >= ?", Date.today).first 
    else 
      self.trimesters.where("number == ?", 1).first
    end
  end
end
