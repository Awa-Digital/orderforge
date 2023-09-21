module Order::Concerns
  module Calculations
    def update_totals
      update(total: order_items.sum(:subtotal))
      payment.update_total(order_total)
    end

    def delivery_charge
      @addr = order_address
      if @addr.present?
        return 0.00 unless @addr.delivery_area_id.present?

        if @addr.delivery_area.price.nil?
          0.00
        else
          puts @addr.delivery_area.id
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

    def discounted_price
      order_total - discount_amount
    end

    def discount_amount
      return 0.00 unless payment

      if payment.voucher.present?
        (order_total * (payment.voucher.discount_rate / 100))
      else
        0.00
      end
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