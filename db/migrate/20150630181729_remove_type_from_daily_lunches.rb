class RemoveTypeFromDailyLunches < ActiveRecord::Migration
  def change
    drop_table :daily_lunches
    create_table :daily_lunches do |t|
      t.timestamps null: false
    end
    add_column :daily_lunches, :name, :string
    add_column :daily_lunches, :vegetarian, :boolean
    add_column :daily_lunches, :smart, :boolean
    remove_column :lunches, :drink, :string 
    remove_column :lunches, :bagel_filling, :string 
    add_column :daily_lunches, :lunch_type, :string
    add_column :daily_lunches, :date_array, :array
    add_column :lunches, :lunch_type, :string
  end
end
