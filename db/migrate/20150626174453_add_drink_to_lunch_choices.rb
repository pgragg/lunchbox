class AddDrinkToLunchChoices < ActiveRecord::Migration
  def change
    remove_column  :lunch_choices, :drink, :string
  end
end
