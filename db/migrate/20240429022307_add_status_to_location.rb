class AddStatusToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :status, :string, default: "active"
    add_column :regions, :status, :string, default: "active"
    add_column :delivery_areas, :status, :string, default: "active"
  end
end
