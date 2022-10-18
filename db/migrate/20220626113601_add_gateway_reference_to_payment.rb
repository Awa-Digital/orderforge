class AddGatewayReferenceToPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :gateway_reference, :string
  end
end
