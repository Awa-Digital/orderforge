class PdfUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def public_id
    "jazzy/#{ENV['MEDIA_SUBFOLDER']}/receipts/#{model.reference}"
  end
end
