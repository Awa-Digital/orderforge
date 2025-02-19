class AddVerificationToInfluencer < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :verification_type, :string
    add_column :influencers, :verified, :boolean, default: false
    add_column :influencers, :verification_document, :string
  end
end
