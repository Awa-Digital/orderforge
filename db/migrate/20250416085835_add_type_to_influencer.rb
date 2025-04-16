class AddTypeToInfluencer < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :affiliate_type, :string, null: false, default: 'individual'
    add_column :influencers, :business_name, :string
    add_index :influencers, :affiliate_type
  end
end
