class DailyLunch < ActiveRecord::Base

  validates :name, presence: true
  validates :lunch_type, presence: true

  default_scope { order('lunch_type ASC') } 
  scope :by_type, ->(type) { where(lunch_type: type)}
  
end
