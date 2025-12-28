class AddGuestTokenHashToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :guest_token_hash, :string
    add_index :orders, :guest_token_hash
  end
end
