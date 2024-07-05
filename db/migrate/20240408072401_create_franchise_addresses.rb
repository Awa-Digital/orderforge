class CreateFranchiseAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :franchise_addresses do |t|
      t.integer :franchise_id
      t.integer :region_id
      t.integer :location_id
      t.string :street
      t.string :longitude
      t.string :latitude

      t.timestamps
    end
  end
end
