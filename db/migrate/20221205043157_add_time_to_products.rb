class AddTimeToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :start_time, :integer, default: 0
    add_column :products, :end_time, :integer, default: 23
  end
end
