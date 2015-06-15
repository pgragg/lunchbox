class SummariesController < ApplicationController
  # before_action :load_summary_and_day
  respond_to :html, :js

  def weekday_on(time)
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[time.wday]
  end 

  def month_on(time)
    months = %w[January February March April May June July August September October November December]
    months[time.month]
  end 

  

  def index 
    @faculty = User.all.where("role = ?", "faculty") 
    @children = Child.all 
    @users = @faculty + @children
    @menus = Menu.all
  end

  def grand_totals
    @users = User.all 
    #self.lunches.by_day(date).load.to_a 
  end

  def show 
    @summary = Summary.find(params[:id]) #This is a weird way to determine the partial I'm using. Not sure I'll keep it. 
    @menus = Menu.all 
    @partial = @summary.summary_partial_for(@summary.id)
    @date = @summary.date
    @weekday = weekday_on(@date)
    @month = month_on(@date)
    
    # ecd_children
    # dwt_lower
    # dwt_mid
    # all_faculty
    # ecd_sp_deliv
    # dwt_sp_deliv
    # dwt_mid + all_faculty + ecd_sp_deliv + dwt_sp_deliv
  end 

  def previous_day
    # session[:date] -= 1 if session[:date] >= 1 
    update_summary!(-1)
    redirect_to :back
  end 

  def next_day
    update_summary!(1)
    redirect_to :back
    # session[:date] += 1 if session[:date] < Menu.master_date_list.count 
  end 


  private 

  def update_summary!(new_value)
    @summary = Summary.find(params[:summary_id])
    authorize @summary, :update?
    @summary.update_attribute(:date, (@summary.date + new_value))
  end


end


# Add lunch summaries pages (2.0) ECD students, ECD faculty, DWT students, DWT faculty, 
# Grand totals.; 