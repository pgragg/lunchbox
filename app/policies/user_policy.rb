class UserPolicy < ApplicationPolicy 
  attr_reader :user

  def initialize(user, menu)
    @user = user
    @menu = menu
  end

  def create? 
    user.present? && user.admin?
  end 

  def index? 
    create?
  end 

  def show?
    user.present? && (@user.id == user.id || user.admin?)
  end 

end 

