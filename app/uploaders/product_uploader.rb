class ProductUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/products/prod_#{model.id}"
  end

  def store_dir
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/products/prod_#{model.id}"
  end

  process resize_to_fit: [428, 428]

  version :thumb do
    process resize_to_fill: [100, 100]
  end
end
