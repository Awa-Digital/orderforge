class AdUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/ads/ad_#{model.id}"
  end

  def store_dir
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/ads/ad_#{model.id}"
  end

  def default_url(*_args)
    ENV.fetch('DEFAULT_AD_IMAGE_URL', nil)
  end

  process resize_to_fit: [736, 314]
end
