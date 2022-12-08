class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :user, optional: true
  belongs_to :voucher, optional: true

  before_create :set_paid

  scope :paid_at_today, -> { select {|p| p.paid_on_today} }
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
      (order.order_total * (voucher.discount_rate / 100))
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
  end

  def payment_total
    (order.order_total - discount).to_f
  end

  def in_kobo
    (payment_total * 100).to_f
  end

  def charges
    order.delivery_charge + order.vat_charge
  end

  def complete
    update(paid: true)
    order.update(status: 'paid', paid: true)
    order.set_processing_data
    order.generate_completion_notification
  end

  def verify
    payment_status = Paystacky.new.verify(self)['data']['status']
    payment_status == 'success'
  end

  def paid_on_today
      paid_today = paid_at.to_date == Date.today.in_time_zone.to_date
      paid_today && paid == true
  end
end
