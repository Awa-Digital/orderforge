# state
class Region < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :location
  has_many :delivery_areas
  has_many :franchise_addresses
  has_many :franchises, through: :franchise_addresses
  include StateManagement

  validates_uniqueness_of :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name id status]
  end

  def self.ransackable_associations(_auth_object = nil)
    [:location]
  end
end
