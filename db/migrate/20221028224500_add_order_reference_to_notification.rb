class AddOrderReferenceToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :order_reference, :integer
    add_column :notifications, :notification_type, :string
  end
end
