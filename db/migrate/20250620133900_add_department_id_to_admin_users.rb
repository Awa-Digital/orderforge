class AddDepartmentIdToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :department_id, :integer
  end
end
