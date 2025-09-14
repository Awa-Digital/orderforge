class Inventory < ApplicationRecord
  include StateManagement
  include Whodunit::Stampable if defined?(Rails::Server)

  has_many :product_inventory_items
  has_many :stock_inventory_items, dependent: :destroy
  has_many :stocks, through: :stock_inventory_items
  has_many :products, through: :product_inventory_items

  validates_uniqueness_of :code

  def self.ransackable_attributes(_auth_object = nil)
    %w[id state status code name description expires]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
