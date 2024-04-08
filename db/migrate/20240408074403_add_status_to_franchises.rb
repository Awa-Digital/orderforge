class AddStatusToFranchises < ActiveRecord::Migration[7.0]
  def change
    add_column :franchises, :status, :string, default: "active"
  end
end
