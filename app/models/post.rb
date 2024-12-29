class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :content, presence: true

  def tag_names=(names)
    self.tags = names.split(",").map do |name|
      Tag.find_or_create_by(name: name.strip.downcase)
    end
  end

  def tag_names
    tags.map(&:name).join(", ")
  end
end
