class Ingredient < ApplicationRecord
  mount_uploader :icon, IconUploader

  has_many :product_ingredients
  has_many :products, through: :product_ingredients
end
