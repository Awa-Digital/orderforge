class AffiliateStoreFrontUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/storefronts/affiliate_#{model.id}"
  end

  def store_dir
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/storefronts/affiliate_#{model.id}"
  end

  # process resize_to_fit: [300, 300]

  # def default_url(*_args)
  #   'AppBranding::DEFAULT_AVATAR_URL'
  # end
end
