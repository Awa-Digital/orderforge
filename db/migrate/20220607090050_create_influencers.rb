class CreateInfluencers < ActiveRecord::Migration[6.1]
  def change
    create_table :influencers do |t|
      t.string :name
      t.string :instagram_handle
      t.string :twitter_handle
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
