class AdUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  storage :file

  # def public_id
  #   "jazzy/#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}_#{DateTime.now.to_i}"
  # end

  def store_dir
    "public/#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}_#{DateTime.now.to_i}"
  end

  def default_url(*args)
    "https://api.jazzysburger.com/sunday-ad.png"
  end

  process resize_to_fit: [1840, 785]
end
