class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.decimal :total, precision: 8, scale: 2
      t.decimal :payment_charges, precision: 8, scale: 2
      t.integer :discount_id
      t.integer :order_id
      t.boolean :paid

      t.timestamps
    end
  end
end
