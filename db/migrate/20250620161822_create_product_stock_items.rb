class CreateProductStockItems < ActiveRecord::Migration[7.0]
  def change
    create_table :product_stock_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
