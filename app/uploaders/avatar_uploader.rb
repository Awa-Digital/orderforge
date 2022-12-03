class AvatarUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  def public_id
    "jazzy/#{ENV['MEDIA_SUBFOLDER']}/users/user_#{model.id}_#{DateTime.now.to_i}"
  end

  process resize_to_fit: [300, 300]

  def default_url(*args)
    "https://res.cloudinary.com/awadigital/image/upload/v1644139435/yaaaga/default_png.png"
  end
end
