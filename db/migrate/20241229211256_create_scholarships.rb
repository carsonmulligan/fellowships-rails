class CreateScholarships < ActiveRecord::Migration[7.2]
  def change
    create_table :scholarships do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :due_date
      t.integer :value

      t.timestamps
    end
  end
end
