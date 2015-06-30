class MenuPolicy < ApplicationPolicy 
  attr_reader :user, :menu

  def initialize(user, menu)
    @user = user
    @menu = menu
  end

  def create? 
    user.present? && user.admin?
  end 
  def index? 
    user.present?
  end 
  def show?
    (user.present? && @menu.id == @user.menu_id)
  end 

  def children?
    user.present? && user.parent? && !user.admin? 
  end 
end 

