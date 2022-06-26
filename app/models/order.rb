# Model for User Cart
class Order < ApplicationRecord
  has_many :order_items
  has_one :payment
  belongs_to :address, optional: true
  belongs_to :user

  validates :status, inclusion: { in: %w[initiated paid completed], message: '%{value} is not a valid status' }

  before_create :set_recipient, :generate_reference_id
  after_create :generate_payment

  def as_json(options = {})
    options[:methods] = %i[delivery_charge vat_charge delivery_address]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def generate_reference_id
    self.reference = "JAZ#{DateTime.now.to_i}"
  end

  def set_recipient
    self.recipient_name = user.full_name
    self.recipient_phone = user.phone_number
    completed = false
  end

  def generate_payment
    create_payment(user_id: user.id, total: order_total)
  end

  def update_totals
    update(total: order_items.sum(:subtotal))
    payment.update_total(order_total)
  end

  def delivery_charge
    0.00
  end

  def vat_charge
    (total.to_i * 0.075).to_f
  end

  def order_total
    (total + vat_charge + delivery_charge).to_f
  end

  def items
    order_items
  end

  def delivery_address
    address
  end
end
