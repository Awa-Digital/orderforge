class CreateProductPurchaseCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :product_purchase_counters do |t|
      t.bigint :product_id

      t.timestamps
    end
  end
end
