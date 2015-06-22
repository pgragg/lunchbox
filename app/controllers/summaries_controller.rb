class SummariesController < ApplicationController
  respond_to :html, :js

  def weekday_on(time)
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[time.wday]
  end 

  def month_on(time)
    months = %w[December January February March April May June July August September October November]
    months[time.month]
  end 

  

  def index 
    @faculty = User.all.where("role = ?", "faculty") #TODO: refactor with scope. 
    @children = Child.all 
    @users = @faculty + @children
    @menus = Menu.all
    @summaries = Summary.all 
  end

  def show 
    @summary = Summary.find(params[:id]) 
    @menus = Menu.all 
    @partial = @summary.summary_partial_for(@summary.id)
    @date = @summary.date
    @weekday = weekday_on(@date)
    @month = month_on(@date)
  end 

  def previous_day
    update_summary!(-1)
    redirect_to :back
  end 

  def next_day
    update_summary!(1)
    redirect_to :back
  end 

  private 

  def update_summary!(new_value)
    @summary = Summary.find(params[:summary_id])
    authorize @summary, :update?
    new_date = @summary.date + new_value
    first_day = Summary.all_menu_date_list.first 
    last_date = Summary.all_menu_date_list.last 
    if new_date >= first_day && new_date <= last_date
      @summary.update_attribute(:date, (new_date))
    else 
      flash[:error] = "You may have tried to display a date which doesn't have any lunches."
    end  
  end
end


