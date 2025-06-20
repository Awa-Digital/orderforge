class RemoveFranchiseIdFromAdminUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :admin_users, :franchise_id, :integer
  end
end
