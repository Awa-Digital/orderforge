class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :voucher, optional: true
end
