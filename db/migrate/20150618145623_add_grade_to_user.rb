class AddGradeToUser < ActiveRecord::Migration
  def change
    remove_column :users, :grade, :integer 
    add_column :users, :grade, :string
  end
end
