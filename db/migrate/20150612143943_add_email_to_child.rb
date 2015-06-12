class AddEmailToChild < ActiveRecord::Migration
  def change
    add_column :children, :email, :string
  end
end
