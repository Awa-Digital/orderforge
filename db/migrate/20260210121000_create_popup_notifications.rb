class CreatePopupNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :popup_notifications do |t|
      t.string :image
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end

