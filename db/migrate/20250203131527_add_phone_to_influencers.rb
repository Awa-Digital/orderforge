class AddPhoneToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :phone_number, :string
    add_column :influencers, :tiktok_handle, :string
    add_column :influencers, :facebook_page_handle, :string
    add_column :influencers, :followers_count, :integer
  end
end
