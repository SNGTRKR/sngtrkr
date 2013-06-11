# encoding: utf-8

class ReleaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  def store_dir
    ":class/images/:id_partition/"
  end

  def default_url
    asset_path("/images/release/#{version_name}/missing.png")
  end

  process resize_to_fit: [500, 500]
  process :quality => 50

  version :release_i do
    process resize_to_fill: [310, 311]
  end

  version :release_carousel do
    process resize_to_fill: [116, 116]
  end

  version :activity_release do
    process resize_to_fill: [40, 40]
  end

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
