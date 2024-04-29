class AddStatusToInventories < ActiveRecord::Migration[7.0]
  def change
    add_column :inventories, :status, :string, default: "active"
  end
end
