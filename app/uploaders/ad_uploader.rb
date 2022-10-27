class AdUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def public_id
    "jazzy/#{ENV['MEDIA_SUBFOLDER']}/ads/ad_#{model.id}_#{DateTime.now.to_i}"
  end


  process resize_to_fit: [368, 157]
end
