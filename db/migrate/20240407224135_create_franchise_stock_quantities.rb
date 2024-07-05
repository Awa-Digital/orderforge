class CreateFranchiseStockQuantities < ActiveRecord::Migration[7.0]
  def change
    create_table :franchise_stock_quantities do |t|
      t.integer :franchise_id
      t.integer :stock_id
      t.decimal :quantity

      t.timestamps
    end
  end
end
