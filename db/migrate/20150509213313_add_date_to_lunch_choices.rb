class AddDateToLunchChoices < ActiveRecord::Migration
  def change
    add_column :lunch_choices, :date, :date
  end
end
