class Scholarship < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  
  validates :name, presence: true
  validates :description, presence: true
  validates :url, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  def self.tag_counts
    pluck(:tags).flatten.group_by(&:itself).transform_values(&:count)
  end

  def self.by_tag(tag)
    where("? = ANY (tags)", tag)
  end
end
