class Bookmark < ApplicationRecord
  belongs_to :scholarship
  validates :user_id, presence: true
  validates :scholarship_id, uniqueness: { scope: :user_id }
end
