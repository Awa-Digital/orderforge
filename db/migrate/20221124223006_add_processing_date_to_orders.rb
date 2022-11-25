class AddProcessingDateToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :processing_date, :datetime
  end
end
