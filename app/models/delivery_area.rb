class DeliveryArea < ApplicationRecord

  has_many :addresses
  has_many :order_addresses

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at]
    super
  end
  # DAY = []
  def price
    day_rate
  end
end
