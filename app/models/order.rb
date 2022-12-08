# frozen_string_literal: true

# Model for User Cart
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :order_address, dependent: :destroy
  # belongs_to :address, optional: true
  belongs_to :user, optional: true

  validates :status, inclusion: { in: %w[initiated paid processing delivering completed], message: "'%{value}' is not a valid status" }

  after_create :generate_reference_id, :generate_payment, :generate_cart_address, :set_recipient

  scope :to_be_processed_today, -> { select {|p| p.processed_today} }

  include Concerns::Verify
  include Concerns::Calculations
  include Concerns::Emails
  include Concerns::Processing


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
    send_processing_email
    @title = "Thank you for your order #{recipient_name}!"
    @body = '⚡️ Your payment has been received and your order is being processed, sit back, relax and we would deliver in no time'
    order_notification(@title, @body)

    deliver_mails
    return if user_id.nil?

    user.update_spend_score
    shout("Notification Delivered for: #{reference}")
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

  def self.update_priorities
    orders = Order.find(Payment.paid_only.paid_at_today.sort_by(&:paid_at).pluck(:id)).select{|o| o.status == 'paid'}
    priority = 1
    orders.each do |o|
      o.update(priority: priority)
      priority += 1
    end
  end
end
