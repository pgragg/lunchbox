class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
