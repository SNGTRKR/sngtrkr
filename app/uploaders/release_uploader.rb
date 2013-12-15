# encoding: utf-8

class ReleaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick
  include Sprockets::Rails::Helper

  def store_dir
    Global.config.upload_directory
  end

  def default_url
    asset_path("/release/#{version_name}/missing.png")
  end

  process resize_to_fit: [500, 500]
  process :quality => 50

  version :large do
    process resize_to_fill: [230, 230]
  end
  version :medium, :from_version => :large do
    process resize_to_fill: [150, 150]
  end

  version :small, :from_version => :medium do
    process resize_to_fill: [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
