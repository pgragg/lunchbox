class LunchChoice < ActiveRecord::Base
  belongs_to :child
  belongs_to :user
  belongs_to :lunch

  scope :by_date, ->(date) { where(date: date)}
  scope :by_lunch_id, ->(lunch_id) { where(lunch_id: lunch_id)}

  def self.build_choice(lunch, user, date)
    user.lunch_choices.build(lunch: lunch, date: date)
  end 

end


#lunch choice is a way to reference the given lunches for any user, or for any day. 