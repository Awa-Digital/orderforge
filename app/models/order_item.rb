class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_save :calculate_subtotal

  def as_json(options = {})
    options[:methods] = %i[subtotal]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def calculate_subtotal
    self.subtotal = (quantity * product.amount)
  end
end
