class AddYearIdToHoliday < ActiveRecord::Migration
  def change
    add_column :holidays, :year_id, :integer
  end
end
