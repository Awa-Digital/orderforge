class RedoDefaultToProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :status, "active"
    change_column_default :orders, :status, "initiated"
  end
end
