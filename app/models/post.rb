class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  # Atribui tags a partir de uma string de nomes separados por vírgula
  def tag_names=(names)
    self.tags = names.split(",").map do |name|
      Tag.find_or_initialize_by(name: name.strip.downcase, post: self)
    end
  end

  # Retorna os nomes das tags associados ao post como uma string
  def tag_names
    tags.map(&:name).join(", ")
  end
end
