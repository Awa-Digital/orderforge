class CreateProductInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :product_inventory_items do |t|
      t.integer :product_id
      t.integer :inventory_id
      t.decimal :quantity

      t.timestamps
    end
  end
end
