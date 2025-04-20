class AddBusinessAddressToAffiliates < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :business_address, :string
  end
end
