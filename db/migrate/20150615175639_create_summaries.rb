class CreateSummaries < ActiveRecord::Migration
  def change
    drop_table :summaries 
    create_table :summaries do |t|
      t.date :date

      t.timestamps null: false
    end
  end
end
