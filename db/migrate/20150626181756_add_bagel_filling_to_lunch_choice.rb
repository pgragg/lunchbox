class AddBagelFillingToLunchChoice < ActiveRecord::Migration
  def change
    remove_column :lunch_choices, :bagel_filling, :string
  end
end 
