class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
