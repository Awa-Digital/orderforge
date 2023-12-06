# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :user, optional: true
  belongs_to :voucher, optional: true

  before_create :set_paid

  scope :paid_at_today, -> { select(&:paid_on_today) }
  scope :paid_only, -> { where(paid: true) }

  def as_json(options = {})
    options[:methods] = %i[voucher]
    options[:except] = %i[created_at updated_at user_id]
    super
  end

  def set_paid
    self.paid = false
  end

  def discount
    if voucher.present?
      (order.amount_to_be_discounted * (voucher.discount_rate / 100))
    else
      0.00
    end
  end

  def update_reference
    update!(reference: "#{order.reference}.T#{DateTime.now.to_i}")
  end

  def update_total(amount)
    update(total: amount)
  end

  def initiate
    update_reference
    update_total(order.order_total)
    Paystacky.new.init(self)
  rescue StandardError => e
    Sentry.capture_exception(e)
  end

  def payment_total
    (order.amount_to_be_discounted - discount + order.delivery_charge).to_f
  end

  def in_kobo
    (payment_total * 100).to_f
  end

  def charges
    order.delivery_charge + order.vat_charge
  end

  def complete
    update(paid: true)
    order.generate_completion_notification
    order.update(status: 'paid', paid: true, order_no: Order.where(paid: true).count + 1)
    order.set_processing_data
  end

  def verify
    payment_status = Paystacky.new.verify(self)['data']['status']
  rescue StandardError => e
    Sentry.capture_exception(e)
  else
    payment_status == 'success'
  end

  def paid_on_today
    paid_today = paid_at.to_date == Date.today.in_time_zone.to_date
    paid_today && paid == true
  end
end
