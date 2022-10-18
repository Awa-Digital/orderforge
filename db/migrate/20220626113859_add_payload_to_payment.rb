class AddPayloadToPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :checkout_url, :string
    add_column :payments, :gateway, :string
    add_column :payments, :payment_id, :string
  end
end
