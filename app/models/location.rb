# country
class Location < ApplicationRecord
  has_many :regions
  validates_uniqueness_of :name, presence: true

  include StateManagement

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
