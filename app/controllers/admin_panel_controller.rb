class AdminPanelController < ApplicationController
  def index 
    @menus = Menu.all 
  end 
  
end
