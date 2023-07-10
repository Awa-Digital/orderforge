class AddRegionIdToDeliveryAreas < ActiveRecord::Migration[6.1]
  def change
    add_column :delivery_areas, :region_id, :integer, default: 1
  end
end
