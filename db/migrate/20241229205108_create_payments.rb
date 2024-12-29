class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.string :user_id
      t.integer :amount
      t.string :currency
      t.string :status

      t.timestamps
    end
  end
end
