class AddBusinessStorefrontImageToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :business_storefront_image, :string
  end
end
