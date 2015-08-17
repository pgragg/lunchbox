class AddId1ToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :id1, :integer
    add_column :matches, :id2, :integer
  end
end
