class Favourite < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :user
  has_many :favourite_items, dependent: :destroy
  has_many :products, through: :favourite_items
end
