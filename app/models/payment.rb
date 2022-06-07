class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :user
  has_one :voucher, optional: true

  def discount
    if voucher.present?
      0.00
    else
      (total * (voucher.disount_rate / 100))
    end
  end

  def total
    order.total - discount
  end

  def charges
    ((order.total * 0.0125) + 100)
  end
end
