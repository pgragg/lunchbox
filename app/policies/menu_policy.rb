class MenuPolicy < ApplicationPolicy 
  def create? 
    user.role == "admin" 
  end 
  def index? 
    user.present?
  end 
end 
