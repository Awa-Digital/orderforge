class AddDeliveryAreaIdToOrderAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :order_addresses, :delivery_area_id, :integer
  end
end
