module Calculations
  extend ActiveSupport::Concern

  def recalculate
    order_items.map(&:calculate_subtotal)
    update_totals
  end

  def update_totals
    update(total: order_items.sum(:subtotal))
    generate_payment unless payment
    payment.update_total(order_total)
  end

  def delivery_charge
    @addr = order_address
    if @addr.present?
      return 0.00 unless @addr.delivery_area_id.present?

      if @addr&.delivery_area&.price&.nil?
        0.00
      else
        # puts @addr.delivery_area.id
        @addr.delivery_area.price
      end
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

  def amount_to_be_discounted
    (total + vat_charge).to_f
  end

  def discounted_price
    amount_to_be_discounted - discount_amount + delivery_charge
  end

  def discount_amount
    return 0.00 unless payment

    if payment.voucher.present?
      (amount_to_be_discounted * (payment.voucher.discount_rate / 100))
    else
      0.00
    end
  end
end

# 26
# 3
#
# 9
#
# 21
#
# 46
#
# 51
#
# 75
#
# 77
