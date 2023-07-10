class Region < ApplicationRecord
  belongs_to :region
  has_many :delivery_areas
end
