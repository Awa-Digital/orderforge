class FavouriteItem < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :favourite
  belongs_to :product
end
