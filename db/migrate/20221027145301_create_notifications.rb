class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :body
      t.string :image
      t.string :analytics_label
      t.integer :user_id
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
