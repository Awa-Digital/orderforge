class AffiliateStoreFrontUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "JJB/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/storefronts/affiliate_#{model.id}"
  end

  def store_dir
    "JJB/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/storefronts/affiliate_#{model.id}"
  end

  # process resize_to_fit: [300, 300]

  # def default_url(*_args)
  #   'https://awa-apps.fra1.cdn.digitaloceanspaces.com/JJB/production/default_png.png'
  # end
end
