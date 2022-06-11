class FavouriteItem < ApplicationRecord
  belongs_to :favourite
  belongs_to :product
end
