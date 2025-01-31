class AddInfluencerIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :influencer_id, :string
  end
end
