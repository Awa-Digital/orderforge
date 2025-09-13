class StockInventoryItem < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :stock
  belongs_to :inventory

  validates_presence_of :quantity
end
