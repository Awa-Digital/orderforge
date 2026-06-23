class CsvUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :fog

  def store_dir
    "#{AppBranding::MEDIA_PREFIX}/#{ENV.fetch('MEDIA_SUBFOLDER', nil)}/csv/"
  end

  def extension_allowlist
    %w[csv]
  end

  def content_type_allowlist
    ['text/csv', 'application/vnd.ms-excel']
  end
end
