class User < ApplicationRecord
  has_many_attached :files

  
  has_many :posts, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
