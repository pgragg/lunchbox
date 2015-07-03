class AddLunchTypeToLunches < ActiveRecord::Migration
  def change
    add_column :lunches, :lunch_type, :string
  end
end
