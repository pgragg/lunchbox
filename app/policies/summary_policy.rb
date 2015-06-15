class SummaryPolicy < ApplicationPolicy 

  def update? 
    user.admin? 
  end

end 