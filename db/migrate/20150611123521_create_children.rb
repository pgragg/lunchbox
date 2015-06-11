class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.integer :grade
      t.string :campus
      t.integer :menu_id

      t.timestamps null: false
    end
  end
end
