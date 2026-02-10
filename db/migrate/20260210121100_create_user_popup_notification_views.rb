class CreateUserPopupNotificationViews < ActiveRecord::Migration[6.1]
  def change
    create_table :user_popup_notification_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :popup_notification, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_popup_notification_views, [:user_id, :popup_notification_id], name: 'index_user_popup_notification_views_on_user_and_popup', unique: true
  end
end

