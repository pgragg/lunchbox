class AddAmountToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :amount, :integer
  end
end
