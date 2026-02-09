# frozen_string_literal: true

class AddFreeDeliveryToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :free_delivery, :boolean, default: false, null: false
  end
end
