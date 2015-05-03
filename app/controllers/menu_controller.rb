class MenuController < ApplicationController
  def index
    @menus = Menu.all
  end
  
  def new
    @menu = Menu.new
  end

  def show
    @menu = Menu.find(params[:id])
  end

  def edit
    @menu = Menu.find(params[:id])
  end

  def update
    @menu = Menu.find(params[:id])
  end

  def create
  end
end
