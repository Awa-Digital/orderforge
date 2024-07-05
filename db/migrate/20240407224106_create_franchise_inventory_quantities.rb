class CreateFranchiseInventoryQuantities < ActiveRecord::Migration[7.0]
  def change
    create_table :franchise_inventory_quantities do |t|
      t.integer :franchise_id
      t.integer :inventory_id
      t.decimal :quantity

      t.timestamps
    end
  end
end
