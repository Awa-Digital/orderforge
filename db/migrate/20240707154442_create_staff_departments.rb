class CreateStaffDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_departments do |t|
      t.bigint :staff_id
      t.bigint :department_id

      t.timestamps
    end
  end
end
