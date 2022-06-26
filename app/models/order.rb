# Model for User Cart
class Order < ApplicationRecord
  has_many :order_items
  has_one :payment
  belongs_to :address
  belongs_to :user

  validates :status, inclusion: { in: %w[initiated completed], message: '%{value} is not a valid status' }

  before_create :set_recipient, :generate_reference_id

  def as_json(options = {})
    options[:methods] = %i[total delivery_charge vat_charge delivery_address]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def generate_reference_id
    self.reference = "JAZ#{DateTime.now.to_i}"
  end

  def set_recipient
    self.recipient_name = user.full_name
    self.recipient_phone = user.phone_number
  end

  def total
    order_items.sum(:subtotal)
  end

  def delivery_charge
    0.00
  end

  def vat_charge
    (total.to_i * 0.075)
  end

  def order_total
    total + vat_charge + delivery_charge
  end

  def items
    order_items
  end

  def delivery_address
    address
  end
end
