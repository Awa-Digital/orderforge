class AddComboToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :combo, :boolean
  end
end
