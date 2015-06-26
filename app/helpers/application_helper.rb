module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def all_dates_in_range(date1, date2)
    start_date = [date1.year,date1.month,date1.day]
    end_date = [date2.year,date2.month,date2.day]
    (Time.new(start_date)..Time.new(end_date).to_date).map{|date| date.strftime("%Y-%m-%d")}
  end 

  def weekday_on(time)
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[time.wday]
  end 

  def holiday_or_weekend?(time)
    is_a_weekend(time) || is_a_holiday(time)
  end

  def is_a_holiday(time)
    Holiday.all_dates.include?(time)
  end

  def is_a_weekend(time)
    weekday_on(time) == "Sunday" || weekday_on(time) == "Saturday"
  end 

  def month_on(time)
    months = %w[December January February March April May June July August September October November]
    months[time.month]
  end 
  
end
