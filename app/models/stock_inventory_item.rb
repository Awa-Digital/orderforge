class StockInventoryItem < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :stock
  belongs_to :inventory

  validates_presence_of :quantity
end
