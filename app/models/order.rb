# frozen_string_literal: true

# Model for User Cart
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :order_address, dependent: :destroy
  # belongs_to :address, optional: true
  belongs_to :user, optional: true

  validates :status, inclusion: { in: %w[initiated paid completed], message: "'%{value}' is not a valid status" }

  after_create :generate_reference_id, :generate_payment, :generate_cart_address, :set_recipient

  NLABEL = "#{self.class.name}_notification"
  NTYPE = "#{self.class.name}_notification"
  LAUNCH_DATE = DateTime.new(2022, 11, 30)

  def as_json(options = {})
    options[:methods] =
      %i[delivery_charge vat_charge delivery_address discount_amount discounted_price order_items payment]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def generate_reference_id
    update(reference: "JAZ#{id}#{DateTime.now.to_i}")
    reference
  end

  def set_processing_date
    update(processing_date: calculate_processing_date)
  end

  def order_type
    return 'preorder' if LAUNCH_DATE > DateTime.now

    'order'
  end

  def calculate_processing_date
    return DateTime.now unless order_type == 'preorder'

    available_date
  end

  def available_date
    launch_date = LAUNCH_DATE
    loop do
      date_filled = Order.where.not(processing_date: nil).select do |o|
        o.processing_date.to_date == launch_date.to_date
      end.count >= 500
      break if date_filled == false

      launch_date += 1.day
    end
    launch_date
  end

  def set_recipient
    return if guest?

    update(recipient_name: user.full_name, recipient_phone: user.phone_number,
           recipient_email: user.email)
  end

  def generate_cart_address
    create_order_address
  end

  def generate_payment
    if guest?
      create_payment(total: order_total)
    else
      create_payment(user_id: user.id, total: order_total)
    end
  end

  def update_totals
    update(total: order_items.sum(:subtotal))
    payment.update_total(order_total)
  end

  def delivery_charge
    @addr = order_address
    if @addr.present?
      return 0.00 unless @addr.delivery_area_id.present?

      delivery_address.delivery_area.price
    else
      0.00
    end
  end

  def vat_charge
    # (total.to_i * 0.075).to_f
    0.00
  end

  def order_total
    (total + vat_charge + delivery_charge.to_f).to_f
  end

  def discounted_price
    order_total - discount_amount
  end

  def discount_amount
    if payment.voucher.present?
      (order_total * (payment.voucher.discount_rate / 100))
    else
      0.00
    end
  end

  def items
    order_items
  end

  def delivery_address
    order_address
  end

  def recipient
    {
      "name": recipient_name,
      "phone": recipient_phone,
      "email": recipient_email
    }
  end

  def guest?
    !user.present?
  end

  def generate_completion_notification
    return if user_id.nil?

    @title = "Thank you for your order #{user.first_name}!"
    @body = '⚡️ Your payment has been received and your order is being processed, sit back, relax and we would deliver in no time'
    order_notification(@title, @body)
    send_processing_email
    send_order_receipt_email
  end

  def order_notification(title, body)
    Notification.create(
      user_id: user_id,
      title: title,
      body: body,
      analytics_label: NLABEL,
      order_reference: reference,
      notification_type: NTYPE
    )
  end

  def order_tracking_url
    "#{ENV['APP_BASE_URL']}/order-details/#{reference}"
  end

  def send_order_receipt_email
    SendgridApi::Email.new.order_receipt_email(self)
  end

  def send_processing_email
    SendgridApi::Email.new.order_processor_email(self)
  end

  def generate_pdf_receipt
    make_pdf
  end

  def make_pdf
    pdf_data = Receipt.new(self).generate_file
    new_file = File.open('receipt.pdf', 'wb')
    new_file.write(pdf_data)
    new_file
  end
end
