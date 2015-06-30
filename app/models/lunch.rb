class Lunch < ActiveRecord::Base
  has_and_belongs_to_many :children, through: :lunch_choices
  has_and_belongs_to_many :users, through: :lunch_choices
  belongs_to :menu

  validates :name, presence: true
  validates :lunch_type, presence: true
  validates :date, presence: true


  default_scope { order('date ASC') } 
  scope :by_day, ->(date) { where(date: date)}
  scope :by_menu, ->(id) { where(menu_id: id)}
  scope :by_type, ->(type) { where(lunch_type: type)}

  
  def weekday
    days = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    days[self.date.wday]
  end 


  # def already_set_on_day_for(user)
  #   if user.lunch_choices.any?
  #     user.lunch_choices.select{|lc| lc.lunch.date = self.date}
  #   end 
  # end 

  
 
end
