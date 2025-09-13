class AddStampsToModels < ActiveRecord::Migration[8.0]
  # rubocop:disable Metrics/MethodLength
  def change
    add_whodunit_stamps :ads
    add_whodunit_stamps :addresses
    add_whodunit_stamps :admin_users
    add_whodunit_stamps :affiliate_views
    add_whodunit_stamps :auths
    add_whodunit_stamps :bank_details
    add_whodunit_stamps :categories
    add_whodunit_stamps :combo_products
    add_whodunit_stamps :delivery_areas
    add_whodunit_stamps :department_roles
    add_whodunit_stamps :departments
    add_whodunit_stamps :devices
    add_whodunit_stamps :favourite_items
    add_whodunit_stamps :franchise_addresses
    add_whodunit_stamps :franchise_inventory_quantities
    add_whodunit_stamps :franchise_product_prices
    add_whodunit_stamps :franchise_stock_quantities
    add_whodunit_stamps :franchises
    add_whodunit_stamps :influencers
    add_whodunit_stamps :ingredients
    add_whodunit_stamps :inventories
    add_whodunit_stamps :locations
    add_whodunit_stamps :notification_settings
    add_whodunit_stamps :notifications
    add_whodunit_stamps :order_addresses
    add_whodunit_stamps :order_items
    add_whodunit_stamps :order_status_stamps
  end
  # rubocop:enable Metrics/MethodLength
end
