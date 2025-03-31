class Stock < ApplicationRecord
  include StateManagement

  validates_uniqueness_of :code

  def self.ransackable_attributes(_auth_object = nil)
    %w[id state status code name description expires]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
