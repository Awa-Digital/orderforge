class FranchiseAddress < ApplicationRecord
  belongs_to :franchise
  belongs_to :region

  def as_json(options = {})
    # options[:methods] = %i[address]
    options[:except] = %i[created_at updated_at longitude latitude street]
    super
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at franchise_id id latitude location_id longitude region_id street updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[franchise region]
  end
end
