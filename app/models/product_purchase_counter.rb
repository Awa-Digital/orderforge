class ProductPurchaseCounter < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :product
end
