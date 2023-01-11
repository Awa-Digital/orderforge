class AddSentGuestReceiptNotificationToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :sent_guest_receipt_notification, :boolean, default: false
  end
end
