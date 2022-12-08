class AddPriorityToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :priority, :integer, default: 0
  end
end
