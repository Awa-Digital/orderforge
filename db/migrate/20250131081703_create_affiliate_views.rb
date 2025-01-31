class CreateAffiliateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :affiliate_views do |t|
      t.string :ip
      t.string :user_agent
      t.string :influencer_id

      t.timestamps
    end
  end
end
