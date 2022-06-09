class Product < ApplicationRecord
  belongs_to :category
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
end
