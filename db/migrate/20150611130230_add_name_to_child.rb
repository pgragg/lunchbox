class AddNameToChild < ActiveRecord::Migration
  def change
    add_column :children, :name, :string
    add_column :children, :email, :string
  end
end
