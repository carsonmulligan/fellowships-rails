class Payment < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :status, presence: true
end
