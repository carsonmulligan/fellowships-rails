class CreateBookmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmarks do |t|
      t.string :user_id
      t.references :scholarship, null: false, foreign_key: true

      t.timestamps
    end
  end
end
