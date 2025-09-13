class Rating < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :user, optional: true
  belongs_to :product
end
