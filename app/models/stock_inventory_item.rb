class StockInventoryItem < ApplicationRecord
  belongs_to :stock
  belongs_to :inventory

  validates_presence_of :quantity
end
