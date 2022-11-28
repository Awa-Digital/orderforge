class AddProductIdToAds < ActiveRecord::Migration[6.1]
  def change
    add_column :ads, :product_id, :integer
    add_column :ads, :url, :string
  end
end
