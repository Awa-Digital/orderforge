class CreateStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs do |t|
      t.bigint :franchise_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :avatar
      t.string :password_digest

      t.timestamps
    end
  end
end
