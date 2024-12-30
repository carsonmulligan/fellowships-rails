class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :trackable, omniauth_providers: [:google_oauth2]

  # Relationships
  has_many :bookmarks, dependent: :destroy
  has_many :scholarships, through: :bookmarks
  has_many :payments, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # Additional fields that may be available from Google
      # user.name = auth.info.name
      # user.image = auth.info.image
    end
  end
end
