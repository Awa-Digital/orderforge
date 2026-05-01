class AddOrderStampToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :order_stamp, :jsonb
  end
end
