# frozen_string_literal: true

# Model for User Cart
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :order_status_stamps, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :order_address, dependent: :destroy
  # belongs_to :address, optional: true
  belongs_to :user, optional: true
  belongs_to :franchise, optional: true
  accepts_nested_attributes_for :order_items
  accepts_nested_attributes_for :order_address

  validates :status,
            inclusion: { in: %w[initiated paid awaiting_processing processing awaiting_packaging packaged delivering completed],
                         message: "'%<value>s' is not a valid status" }

  after_create :generate_reference_id, :generate_payment, :generate_cart_address, :set_recipient
  after_update :send_update_notifications

  scope :to_be_processed_today, -> { select(&:processed_today) }
  scope :stale_orders, lambda {
    where(status: ["initiated"])
      .where("created_at < ?", Date.today)
      .where("updated_at < ?", Date.today)
      .where("processing_date IS NULL OR processing_date < ?", Date.today)
  }

  include Verify
  include Calculations
  include Emails
  include Notifications
  include Processing

  def as_json(options = {})
    options[:methods] =
      %i[next_step next_action delivery_charge vat_charge delivery_address discount_amount discounted_price order_items payment]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[reference recipient_name recipient_phone recipient_email order_no]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[products user payment order_address]
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
      create_payment(total: order_total) unless payment.present?
    else
      create_payment(user_id: user.id, total: order_total) unless payment.present?
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
      name: recipient_name,
      phone: recipient_phone,
      email: recipient_email
    }
  end

  def guest?
    !user.present?
  end

  def generate_completion_notification
    next_order_no = Order.where(paid: true).all.count + 1
    update(status: 'paid', paid: true, order_no: next_order_no)

    OrderMailer.with(reference:).coy_order_email.deliver
    return if user_id.nil?

    user.update_spend_score
    update(processing_date: calculate_processing_date)
    Order.update_priorities
    increment_products_counter
  end

  def increment_products_counter
    order_items.each do |order_item|
      order_item.quantity.times do
        ProductPurchaseCounter.create(
          product_id: order_item.product_id,
          order_item_id: order_item.id
        )
      end
    end
    nil
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
    orders = Order.joins(:payment)
                  .where(payments: { paid: true })
                  .where(status: 'paid')
                  .order('payments.paid_at')
    priority = 1
    orders.each do |o|
      o.update(priority:)
      priority += 1
    end
  end
end
