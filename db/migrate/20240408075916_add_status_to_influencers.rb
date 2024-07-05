class AddStatusToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :status, :string, default: "active"
  end
end
