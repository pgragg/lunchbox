class CreateChildrenLunches < ActiveRecord::Migration
  def change
    create_join_table :lunches, :children, table_name: :children_lunches do |t|
      t.references :children, index: true
      t.references :lunch, index: true
    end
    add_foreign_key :lunch_choices, :children
    add_foreign_key :lunch_choices, :lunches
  end
end
