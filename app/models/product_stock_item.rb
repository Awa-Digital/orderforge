class ProductStockItem < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :product
  belongs_to :stock
end
