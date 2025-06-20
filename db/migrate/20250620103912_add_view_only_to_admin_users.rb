class AddViewOnlyToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :view_only, :boolean
  end
end
