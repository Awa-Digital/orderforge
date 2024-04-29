class AddStatusToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :status, :string, default: "active"
  end
end
