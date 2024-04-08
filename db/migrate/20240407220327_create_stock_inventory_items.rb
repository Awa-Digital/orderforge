class CreateStockInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_inventory_items do |t|
      t.integer :stock_id
      t.integer :inventory_id
      t.decimal :quantity

      t.timestamps
    end
  end
end
