class AddMenuIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :menu_id, :integer
  end
end
