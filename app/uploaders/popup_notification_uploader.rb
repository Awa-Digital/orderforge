class PopupNotificationUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # include Cloudinary::CarrierWave

  storage :fog

  def public_id
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/popup_notifications/popup_notification_#{model.id}"
  end

  def store_dir
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/popup_notifications/popup_notification_#{model.id}"
  end

  # Adjust size as needed for popup images
  process resize_to_fit: [880, 960]
end
