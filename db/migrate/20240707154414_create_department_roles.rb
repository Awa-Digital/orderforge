class CreateDepartmentRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :department_roles do |t|
      t.bigint :department_id
      t.bigint :role_id

      t.timestamps
    end
  end
end
