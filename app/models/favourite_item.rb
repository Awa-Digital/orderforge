class FavouriteItem < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :favourite
  belongs_to :product
end
