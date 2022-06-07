class OrderItem < ApplicationRecord
  belongs_to :order

  def as_json(options = {})
    options[:methods] = %i[subtotal]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def subtotal
    (quantity * product.amount)
  end
end
