class AddChildIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :child_id, :integer
  end
end
