class Influencer < ApplicationRecord
  has_many :vouchers
  has_secure_password
end
