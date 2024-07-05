class Category < ApplicationRecord
  include StateManagement

  mount_uploader :image, CatUploader

  has_many :products
  has_many :subcategories
  validates :title, uniqueness: true

  default_scope { where(status: "active") }

  def as_json(options = {})
    # options[:methods] = %i[category]
    options[:except] = %i[created_at updated_at]
    super
  end
end
