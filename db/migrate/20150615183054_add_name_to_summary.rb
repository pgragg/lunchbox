class AddNameToSummary < ActiveRecord::Migration
  def change
    add_column :summaries, :name, :string
  end
end
