class Bagel < Lunch
  has_one :menu, through: :lunch, autosave: false 
end
