class Favourite < ApplicationRecord
  belongs_to :user
  has_many :favourite_items
end
