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

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def fixed(n)
    "col-xl-#{n} col-lg-#{n} col-md-#{n} col-sm-#{n} col-xs-#{n}" 
  end
  
  def all_dates_in_range(date1, date2)
    
    start_date = [date1.year, date1.month, date1.day]
    end_date = [date2.year, date2.month, date2.day]
    start_date = DateTime.parse("#{start_date[0].to_s}-#{start_date[1].to_s}-#{start_date[2].to_s}")
    end_date = DateTime.parse("#{end_date[0].to_s}-#{end_date[1].to_s}-#{end_date[2].to_s}")
    (start_date..end_date).map {|date| date.strftime("%Y-%m-%d")}
  end 

  def weekday_on(time)
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[sanitize_time(time).wday]
  end 

  def sanitize_time(time)
    time = DateTime.parse(time) if time.class == String
    time
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
    sanitize_time(time)
    months[time.month]
  end 

  def check_for_year
    if (Year.all.last == nil || Year.all.last.end_date < Date.today)
      year = Year.new(start_date: Date.today, end_date: Date.today + 365)
      year.save!
      check_for_trimesters(year)
    end
  end

  def check_for_trimesters(year)
    if year.trimesters.first == nil 
      year.trimesters.create(number: 1, start_date: year.start_date, end_date: year.start_date + 90)
      year.trimesters.create(number: 2, start_date: year.start_date + 91, end_date: year.start_date + 181)
      year.trimesters.create(number: 3, start_date: year.start_date + 182, end_date: year.end_date) 
      Trimester.all.each {|trim| trim.save!}
    end
  end

end
