class AddBagelFillingToLunchChoice < ActiveRecord::Migration
  def change
    add_column :lunch_choices, :bagel_filling, :string
  end
end
