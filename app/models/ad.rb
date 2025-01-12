class Ad < ApplicationRecord
  mount_uploader :image, AdUploader

  belongs_to :product, optional: true

  scope :active_ads, -> { select(&:active_status) }

  def as_json(options = {})
    options[:methods] = %i[active_status]
    options[:except] = %i[created_at updated_at]
    super
  end

  def active_status
    expiration_date >= Date.today
  end


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "expiration_date", "id", "image", "product_id", "title", "updated_at", "url"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product"]
  end
end
