class AddPremiumToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :premium, :boolean, default: false
    add_index :users, :premium
  end
end 