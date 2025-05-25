class AddQuantityToComboProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :combo_products, :quantity, :integer
  end
end
