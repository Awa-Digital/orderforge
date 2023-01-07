class AdUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}"
  end

  def store_dir
    "#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}"
  end

  def default_url(*args)
    "https://api.jazzysburger.com/sunday-ad.png"
  end

  process resize_to_fit: [1840, 785]
end
