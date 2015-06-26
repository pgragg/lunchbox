class CreateBagels < ActiveRecord::Migration
  def change
    create_table :bagels do |t|
      t.string :bagel_filling

      t.timestamps null: false
    end
  end
end
