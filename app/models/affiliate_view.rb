class AffiliateView < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :influencer

  after_create :increment_generated_views_counter

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id influencer_id ip updated_at user_agent]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["influencer"]
  end

  private

  def increment_generated_views_counter
    influencer.increment!(:generated_views)
  end
end
