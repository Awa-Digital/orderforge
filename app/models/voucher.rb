class Voucher < ApplicationRecord
  belongs_to :influencer
  has_many :payments
end
