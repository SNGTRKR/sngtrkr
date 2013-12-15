# encoding: utf-8

class ArtistUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick
  include Sprockets::Rails::Helper

  def store_dir
    Global.config.upload_directory
  end

  def default_url
    asset_path("/images/artist/#{version_name}/missing.png")
  end

  process resize_to_fit: [800, 800]
  process :quality => 50

  version :large do
    process resize_to_fill: [200, 200]
  end
  version :medium, :from_version => :large do
    process resize_to_fill: [100, 100]
  end

  version :small, :from_version => :medium do
    process resize_to_fill: [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
