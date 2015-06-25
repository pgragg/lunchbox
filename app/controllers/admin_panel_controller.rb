class AdminPanelController < ApplicationController
  def index 
    @menus = Menu.all 
  end 

  def show 

  end 
  
end
