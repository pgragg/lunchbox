class AddMenuIdToLunches < ActiveRecord::Migration
  def change
    add_column :lunches, :menu_id, :integer
  end
end
