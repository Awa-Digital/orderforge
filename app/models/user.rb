class User < ApplicationRecord
  has_many :orders
  has_many :payments
  has_one :favourite
end
