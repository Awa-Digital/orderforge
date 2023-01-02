class AddNotificationsBooleansToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :sent_receipt_notification, :boolean, default: false
    add_column :orders, :sent_processing_notification, :boolean, default: false
    add_column :orders, :sent_delivering_notification, :boolean, default: false
    add_column :orders, :sent_completed_notification, :boolean, default: false
  end
end
