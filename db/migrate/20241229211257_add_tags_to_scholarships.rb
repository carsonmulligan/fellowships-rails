class AddTagsToScholarships < ActiveRecord::Migration[7.2]
  def change
    add_column :scholarships, :tags, :string, array: true, default: []
    add_index :scholarships, :tags, using: 'gin'
  end
end
