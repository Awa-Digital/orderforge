class AddSubtotalToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :subtotal, :decimal, precision: 8, scale: 2, default: 0.00
  end
end
