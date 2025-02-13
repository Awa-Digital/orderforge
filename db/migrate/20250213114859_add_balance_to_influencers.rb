class AddBalanceToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :balance, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
