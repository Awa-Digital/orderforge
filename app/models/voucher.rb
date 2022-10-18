class Voucher < ApplicationRecord
  belongs_to :influencer
  has_many :payments

  def as_json(options = {})
    # options[:methods] = %i[delivery_charge vat_charge delivery_address discount_amount discounted_price]
    options[:except] = %i[created_at updated_at influencer_id id]
    super
  end
end
