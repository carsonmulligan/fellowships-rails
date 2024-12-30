class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relationships
  has_many :bookmarks, dependent: :destroy
  has_many :scholarships, through: :bookmarks
  has_many :payments, dependent: :destroy
end
