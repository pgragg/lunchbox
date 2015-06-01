FactoryGirl.define do
  factory :lunch_choice do
    transient do
      chosen_by nil
      user nil
      lunch nil
      day nil 
      # nil is a sensible default, we don't want our factories creating
      # extra data unnecessarily. It slows your test suite down
    end
 

  end
end