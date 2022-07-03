class AddRecipientEmailToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :recipient_email, :string
  end
end
