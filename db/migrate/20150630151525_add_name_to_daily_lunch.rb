class AddNameToDailyLunch < ActiveRecord::Migration
  def change
    add_column :daily_lunches, :name, :string
    add_column :daily_lunches, :vegetarian, :boolean
    add_column :daily_lunches, :smart, :boolean
  end
end
