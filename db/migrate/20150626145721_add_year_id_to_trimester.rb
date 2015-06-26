class AddYearIdToTrimester < ActiveRecord::Migration
  def change
    add_column :trimesters, :year_id, :integer
  end
end
