class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :address_id
      t.integer :user_id
      t.string :status
      t.boolean :completed
      t.boolean :paid

      t.timestamps
    end
  end
end
