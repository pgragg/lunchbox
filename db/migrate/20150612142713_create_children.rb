class CreateChildren < ActiveRecord::Migration
  def change
    drop_table :children 
    create_table :children do |t|
      t.string :grade
      t.string :campus
      t.integer :menu_id
      t.string :first_name
      t.string :last_name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
