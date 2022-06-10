class Product < ApplicationRecord
  mount_uploader :image, ProductUploader

  belongs_to :category
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients

  validates :title,
            :description,
            :category_id,
            :amount, presence: true

  def as_json(options = {})
    options[:methods] = %i[category]
    options[:except] = %i[created_at updated_at user_id]
    super
  end
end
