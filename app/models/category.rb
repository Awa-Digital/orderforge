class Category < ApplicationRecord
  mount_uploader :image, CatUploader

  has_many :products
  has_many :subcategories

  def as_json(options = {})
    # options[:methods] = %i[category]
    options[:except] = %i[created_at updated_at]
    super
  end
end
