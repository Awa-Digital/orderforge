class AddDeliveryAreaIdToAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :delivery_area_id, :integer
    remove_column :addresses, :city, :string
  end
end
