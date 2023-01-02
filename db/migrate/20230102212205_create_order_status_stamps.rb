class CreateOrderStatusStamps < ActiveRecord::Migration[6.1]
  def change
    create_table :order_status_stamps do |t|
      t.integer :auth_id
      t.integer :order_id
      t.string :message
      t.string :action, default: "update"
      t.string :action_name

      t.timestamps
    end
  end
end
