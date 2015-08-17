class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.boolean :dismissed

      t.timestamps null: false
    end
  end
end
