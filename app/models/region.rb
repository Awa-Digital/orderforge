# state
class Region < ApplicationRecord
  belongs_to :location
  has_many :delivery_areas
end
