class FranchiseProductPrice < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :franchise
  belongs_to :product

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount created_at franchise_id id product_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[franchise product]
  end
end
