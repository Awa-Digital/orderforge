class FranchiseStockQuantity < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)
end
