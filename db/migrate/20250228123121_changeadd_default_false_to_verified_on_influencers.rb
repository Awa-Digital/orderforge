class ChangeaddDefaultFalseToVerifiedOnInfluencers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :influencers, :verified, from: nil, to: false
  end
end
