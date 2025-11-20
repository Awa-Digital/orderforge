# frozen_string_literal: true

module OrderItemSnapshot
  extend ActiveSupport::Concern

  def create_line_snapshot!
    unit_price = product.price(order.franchise_id)
    self.snapshot = {
      product_id: product_id,
      product_name: product.title,
      quantity: quantity,
      unit_price: unit_price.to_f,
      subtotal: subtotal.to_f,
      stamped_at: Time.current.iso8601
    }
    save!
  end
end
