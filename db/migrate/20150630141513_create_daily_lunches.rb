class CreateDailyLunches < ActiveRecord::Migration
  def change
    create_table :daily_lunches do |t|

      t.timestamps null: false
    end
  end
end
