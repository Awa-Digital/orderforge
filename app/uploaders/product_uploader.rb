class ProductUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "JJB/#{ENV['MEDIA_SUBFOLDER']}/products/prod_#{model.id}"
  end

  def store_dir
    "JJB/#{ENV['MEDIA_SUBFOLDER']}/products/prod_#{model.id}"
  end
end
