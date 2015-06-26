class AddNumberToTrimester < ActiveRecord::Migration
  def change
    add_column :trimesters, :number, :integer
  end
end
