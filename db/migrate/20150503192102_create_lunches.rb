class CreateLunches < ActiveRecord::Migration
  def change
    drop_table :lunches 
    create_table :lunches do |t|
      t.date :date
      t.string :name
      t.string :description
      t.boolean :vegetarian
      t.boolean :smart

      t.timestamps null: false
    end
  end
end
