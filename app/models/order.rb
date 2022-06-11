# Model for User Cart
class Order < ApplicationRecord
  has_many :order_items
  has_one :payment

  before_save :generate_reference_id

  def as_json(options = {})
    options[:methods] = %i[total]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def generate_reference_id
    self.reference = "JAZ#{DateTime.now.to_i}"
  end

  def total
    order_items.sum(:subtotal)
  end

  def delivery_charges
    0.00
  end

  def vat_charge
    (total.to_i * 0.075)
  end

  def items
    order_items
  end

  def delivery_address
    Address.find_by(address_id)
  end

  # def method_name; end
end
