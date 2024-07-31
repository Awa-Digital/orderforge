class ProductInventoryItem < ApplicationRecord
  belongs_to :product
  belongs_to :inventory
end
