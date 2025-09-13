class ProductPurchaseCounter < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :product
end
