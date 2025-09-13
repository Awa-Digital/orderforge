class ProductInventoryItem < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :product
  belongs_to :inventory
end
