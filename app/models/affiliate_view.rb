class AffiliateView < ApplicationRecord
  belongs_to :influencer

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id influencer_id ip updated_at user_agent]
  end

  def self.ransackable_associations(auth_object = nil)
    ["influencer"]
  end
end
