class AddCampusToUser < ActiveRecord::Migration
  def change
    add_column :users, :campus, :string
  end
end
