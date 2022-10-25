class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.string :build_number
      t.string :device_token
      t.string :device_name
      t.string :serial_number

      t.timestamps
    end
  end
end
