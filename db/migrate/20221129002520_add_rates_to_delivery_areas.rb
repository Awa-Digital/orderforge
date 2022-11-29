class AddRatesToDeliveryAreas < ActiveRecord::Migration[6.1]
  def change
    add_column :delivery_areas, :day_rate, :decimal, precision: 8, scale: 2
    add_column :delivery_areas, :dusk_rate, :decimal, precision: 8, scale: 2
    add_column :delivery_areas, :night_rate, :decimal, precision: 8, scale: 2
    add_column :delivery_areas, :dawn_rate, :decimal, precision: 8, scale: 2
  end
end
