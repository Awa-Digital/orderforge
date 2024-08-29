class AddFranchiseIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :franchise_id, :integer
  end
end
