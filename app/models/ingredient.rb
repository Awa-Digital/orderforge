class Ingredient < ApplicationRecord
  mount_uploader :icon, IconUploader

  has_many :product_ingredients
  has_many :products, through: :product_ingredients

  validates :name, presence: true
  validates :name, uniqueness: true

  def as_json(options = {})
    # options[:methods] = %i[category ingredients review_rating review_count]
    options[:except] = %i[created_at updated_at]
    super
  end
end
