class FranchiseInventoryQuantity < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)
end
