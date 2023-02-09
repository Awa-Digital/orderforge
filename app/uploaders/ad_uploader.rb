class AdUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "JJB/#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}"
  end

  def store_dir
    "JJB/#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}"
  end

  def default_url(*args)
    "https://api.jazzysburger.com/sunday-ad.png"
  end

  process resize_to_fit: [736, 314]
end
