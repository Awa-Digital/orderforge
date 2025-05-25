class CreateComboProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :combo_products do |t|
      t.integer :combo_id
      t.integer :product_id

      t.timestamps
    end
  end
end
