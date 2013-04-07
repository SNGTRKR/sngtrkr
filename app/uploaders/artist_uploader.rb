# encoding: utf-8

class ArtistUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    ":class/images/:id_partition/"
  end

  def default_url
    asset_path("images/#{version_name}/missing.png")
  end

  process resize_to_fit: [800, 800]
  process :quality => 50

  version :profile do
    process resize_to_fill: [310, 369]
  end

  version :recommend do
    process resize_to_fill: [212, 178]
  end

  version :large do
    process resize_to_fill: [200, 280]
  end

  version :manage do
    process resize_to_fill: [100, 100]
  end

  version :medium, :from_version => :large do
    process resize_to_fill: [100, 100]
  end

  version :small, :from_version => :medium do
    process resize_to_fill: [50, 50]
  end

  version :sidebar_suggest do
    process resize_to_fill: [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
