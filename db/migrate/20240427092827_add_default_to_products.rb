class AddDefaultToProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :status, "initiated"
  end
end
