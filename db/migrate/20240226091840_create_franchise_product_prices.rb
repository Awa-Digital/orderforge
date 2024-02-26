class CreateFranchiseProductPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :franchise_product_prices do |t|
      t.integer :franchise_id
      t.integer :product_id
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
