if Rails.env == 'staging' or Rails.env == 'production'
  BUCKET_ENV = 'production'
elsif Rails.env == 'test'
  BUCKET_ENV = 'test'
elsif Rails.env == 'development'
  BUCKET_ENV = 'production'
end

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['SNGTRKR_AWS_ID'],        # required
    :aws_secret_access_key  => ENV['SNGTRKR_AWS_KEY'],       # required
    :region                 => 'eu-west-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = "sngtrkr-"+BUCKET_ENV                     # required
  config.asset_host = "http://sngtrkr-"+BUCKET_ENV+".s3.amazonaws.com"
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end