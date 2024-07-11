class AddStatusToStaffs < ActiveRecord::Migration[7.0]
  def change
    add_column :staffs, :status, :string, default: "active"
    add_column :staff_departments, :status, :string, default: "active"
    add_column :roles, :status, :string, default: "active"
    add_column :departments, :status, :string, default: "active"
    add_column :department_roles, :status, :string, default: "active"
  end
end
