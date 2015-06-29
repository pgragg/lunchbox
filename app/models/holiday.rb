class Holiday < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :trimester


  def dates 
    all_dates_in_range(self.start_date, self.end_date)
  end 

  def self.all_dates
    dates = []
    self.all.each do |holiday| 
      dates << holiday.dates
    end
    dates.flatten
  end


end
