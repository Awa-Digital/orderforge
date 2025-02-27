class AddVerificationVideoLinkToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :verification_video_link, :string
  end
end
