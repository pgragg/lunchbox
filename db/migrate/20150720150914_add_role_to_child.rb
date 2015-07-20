class AddRoleToChild < ActiveRecord::Migration
  def change
    add_column :children, :role, :string
  end
end
