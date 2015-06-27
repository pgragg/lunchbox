class AddDrinkToLunchChoices < ActiveRecord::Migration
  def change
    add_column  :lunch_choices, :drink, :string
  end
end
