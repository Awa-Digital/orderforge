class AddFranchiseIdToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :franchise_id, :integer
  end
end
