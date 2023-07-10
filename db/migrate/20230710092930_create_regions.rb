class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.integer :location_id

      t.timestamps
    end
  end
end
