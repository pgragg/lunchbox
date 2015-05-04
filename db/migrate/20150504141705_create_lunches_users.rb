class CreateLunchesUsers < ActiveRecord::Migration
  def change
    create_join_table :lunches, :users, table_name: :lunches_users do |t|
      t.references :user, index: true
      t.references :lunch, index: true
    end
    add_foreign_key :lunch_choices, :users
    add_foreign_key :lunch_choices, :lunches
  end
end
