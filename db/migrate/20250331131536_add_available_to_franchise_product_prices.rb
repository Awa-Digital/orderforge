class AddAvailableToFranchiseProductPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :franchise_product_prices, :available, :boolean, default: true
  end
end
