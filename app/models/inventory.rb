class Inventory < ApplicationRecord
  include StateManagement

  has_many :product_inventory_item

  validates_uniqueness_of :code

  def self.ransackable_attributes(_auth_object = nil)
    %w[code name description]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
