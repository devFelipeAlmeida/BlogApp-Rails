class Tag < ApplicationRecord
  belongs_to :post

  validates :name, presence: true, uniqueness: { scope: :post_id }
end
