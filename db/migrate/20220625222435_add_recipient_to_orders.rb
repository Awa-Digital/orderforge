class AddRecipientToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :recipient_name, :string
    add_column :orders, :recipient_phone, :string
  end
end
