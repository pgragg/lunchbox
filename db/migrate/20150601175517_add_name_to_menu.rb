class AddNameToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :name, :string
  end
end
