class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  require 'will_paginate'

  skip_before_filter :auth_user

  # def visit_menu
  #   @menu = user.id #user here refers to 
  #   redirect_to @menu 
  # end 

  def index
    # if params[:parameter] && params[:value] #eg. last_name or grade 
    #   parameter = params[:parameter]
    #   value = params[:value] # eg. "Anastos" or "threes"
    # end 
    # @users = User.all.where("#{parameter} = ?", "#{value}")
    @users = User.search(params[:search_term],params[:search]).order(sort_column + " " + sort_direction)#.paginate(:per_page => 5, :page => params[:page])
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
    @user = User.find(params[:id])
    authorize @user 
    if @user.update_attributes(user_params)
    flash[:notice] = "User's information was updated."
    redirect_to users_path if current_user.admin? 
    else
      flash[:error] = "There was an error editing the user. Please try again."
      render :edit
    end 
  end

  def destroy
    @user = User.find(params[:id])
    unless @user.admin? 
      @user.delete 
    end
    redirect_to :back
  end

  def show 
    @user = User.find(params[:id])
    authorize @user 
  end 

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :grade, :campus, :menu_id, :email)
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end

