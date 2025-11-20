# frozen_string_literal: true

class Order
  module Snapshot
    extend ActiveSupport::Concern

    def create_order_snapshot!
      order_items.each(&:create_line_snapshot!)

      stamp = {
        order_id: id,
        reference: reference,
        status: status,
        franchise_id: franchise_id,
        items: order_items.map { |item| item.snapshot.presence || {} },
        subtotal: total.to_f,
        delivery_charge: delivery_charge.to_f,
        vat_charge: vat_charge.to_f,
        discount_amount: discount_amount.to_f,
        order_total: order_total.to_f,
        recipient: recipient,
        confirmed_at: Time.current,
        stamped_at: Time.current.iso8601
      }

      update!(order_stamp: stamp)
      stamp
    end

    def frozen_totals
      order_stamp.presence || {}
    end
  end
end
