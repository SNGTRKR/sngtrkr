CarrierWave.configure do |config|
  # if Rails.configuration.x.carrierwave.test_mode
  #   config.storage = :file
  #   config.root = File.join(Rails.root + "public") if Rails.env.development? or Rails.env.test?
  # else
    config.fog_credentials = {
        :provider => 'AWS', # required
        :aws_access_key_id => ENV['SNGTRKR_AWS_ID'], # required
        :aws_secret_access_key => ENV['SNGTRKR_AWS_KEY'], # required
        :region => 'eu-west-1', # optional, defaults to 'us-east-1'
    }
    config.fog_directory = "sngtrkr-production" # required
    config.asset_host = "http://sngtrkr-production.s3.amazonaws.com"
    config.fog_public = true # optional, defaults to true
    config.fog_attributes = {
      'Cache-Control' => 'max-age=315576000',
      'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
    }
  # end

  if Rails.env.test?
    config.enable_processing = false
  end

end

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end