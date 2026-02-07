# frozen_string_literal: true

class AddCommissionRateToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :commission_rate, :decimal, precision: 5, scale: 2, default: 20.0, null: false
  end
end
