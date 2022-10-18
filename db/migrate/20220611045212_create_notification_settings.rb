class CreateNotificationSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :notification_settings do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.boolean :push_notifications, default: true
      t.boolean :app_updates, default: true
      t.boolean :promotions, default: true
      t.boolean :receipts, default: true
      t.boolean :newsletter, default: true

      t.timestamps
    end
  end
end
