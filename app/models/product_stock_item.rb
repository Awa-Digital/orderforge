class ProductStockItem < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :product
  belongs_to :stock
end
