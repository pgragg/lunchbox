class DailyLunches < ActiveRecord::Migration
  def change
    create_table :daily_lunches do |t|
      t.timestamps null: false
    end
    add_column :daily_lunches, :name, :string
    add_column :daily_lunches, :vegetarian, :boolean
    add_column :daily_lunches, :smart, :boolean
    add_column :daily_lunches, :lunch_type, :string
  end
end
