class CreateLunchChoices < ActiveRecord::Migration
  def change
    create_table :lunch_choices do |t|
      t.references :child, index: true
      t.references :lunch, index: true

      t.timestamps null: false
    end
    add_foreign_key :lunch_choices, :children
    add_foreign_key :lunch_choices, :lunches
  end
end