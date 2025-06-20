class RemoveSuperUserFromAdminUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :admin_users, :super_user
    remove_column :admin_users, :view_only
  end
end
