class AddSlugToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :slug, :string
  end
end
