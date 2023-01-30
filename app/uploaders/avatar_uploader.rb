class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Cloudinary::CarrierWave

  def public_id
    "jazzy/#{ENV['MEDIA_SUBFOLDER']}/users/user_#{model.id}_#{DateTime.now.to_i}"
  end

  process resize_to_fit: [300, 300]

  def default_url(*_args)
    'https://awa-apps.fra1.cdn.digitaloceanspaces.com/JJB/production/default_png.png'
  end
end
