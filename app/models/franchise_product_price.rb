class FranchiseProductPrice < ApplicationRecord
  belongs_to :franchise
  belongs_to :product
end
