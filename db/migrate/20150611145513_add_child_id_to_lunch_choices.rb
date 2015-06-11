class AddChildIdToLunchChoices < ActiveRecord::Migration
  def change
    add_column :lunch_choices, :child_id, :integer
    add_index :lunch_choices, :child_id
  end
end
