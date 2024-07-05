class AddDataToOrderAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :order_addresses, :region_id, :integer
    add_column :order_addresses, :location_id, :integer
  end
end
