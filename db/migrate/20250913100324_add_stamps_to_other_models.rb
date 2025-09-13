class AddStampsToOtherModels < ActiveRecord::Migration[8.0]
  # rubocop:disable Metrics/MethodLength
  def change
    add_whodunit_stamps :orders
    add_whodunit_stamps :password_reset_tokens
    add_whodunit_stamps :payments
    add_whodunit_stamps :product_ingredients
    add_whodunit_stamps :product_inventory_items
    add_whodunit_stamps :product_purchase_counters
    add_whodunit_stamps :product_stock_items
    add_whodunit_stamps :products
    add_whodunit_stamps :ratings
    add_whodunit_stamps :regions
    add_whodunit_stamps :removables
    add_whodunit_stamps :reports
    add_whodunit_stamps :roles
    add_whodunit_stamps :staff_departments
    add_whodunit_stamps :staffs
    add_whodunit_stamps :stock_inventory_items
    add_whodunit_stamps :stocks
    add_whodunit_stamps :subcategories
    add_whodunit_stamps :transactions
    add_whodunit_stamps :users
    add_whodunit_stamps :vouchers
  end
  # rubocop:enable Metrics/MethodLength
end
