class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.integer :admin_user_id
      t.string :file_name
      t.string :csv_url
      t.jsonb :filters

      t.timestamps
    end
  end
end
