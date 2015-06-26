class AddDrinkToLunchChoices < ActiveRecord::Migration
  def change
    add_column  :lunch_choices, :drink, :string
    remove_column :lunch_choices, :drink_id, :integer
  end
end
