class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def edit
    @user = User.find(params[:id])
    authorize @user 
  end

  def update
  end

  def destroy
  end

  def show 
    @user = User.find(params[:id])
    authorize @user 
  end 
end

