class CreateDeliveryAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :delivery_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
