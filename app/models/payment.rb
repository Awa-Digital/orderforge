class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :voucher, optional: true

  before_create :set_paid

  def as_json(options = {})
    # options[:methods] = %i[delivery_charge vat_charge delivery_address]
    options[:except] = %i[created_at updated_at user_id]
    super
  end

  def set_paid
    self.paid = false
  end

  def discount
    if voucher.present?
      (payment_total * (voucher.disount_rate / 100))
    else
      0.00
    end
  end

  def update_reference
    self.reference = "#{order.reference}.T#{DateTime.now.to_i}"
    save
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
  end

  def verify
    payment_status = Paystacky.new.verify(self)['data']['status']
    payment_status == 'success'
  end
end
