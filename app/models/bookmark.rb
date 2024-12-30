class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :scholarship
  
  validates :user_id, presence: true
  validates :scholarship_id, presence: true
  validates :user_id, uniqueness: { scope: :scholarship_id }
end
