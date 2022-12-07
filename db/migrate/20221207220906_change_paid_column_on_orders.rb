class ChangePaidColumnOnOrders < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :paid, :boolean, default: false
  end
end
