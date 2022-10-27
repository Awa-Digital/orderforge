class Ad < ApplicationRecord
  mount_uploader :image, AdUploader

  scope :active_ads, -> { select {|ad| ad.active_status} }

  def as_json(options = {})
    options[:methods] = %i[active_status]
    options[:except] = %i[created_at updated_at]
    super
  end

  def active_status
    expiration_date >= Date.today 
  end
end
