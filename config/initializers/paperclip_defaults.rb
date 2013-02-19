if Rails.env == 'staging' or Rails.env == 'production'
  BUCKET_ENV = 'production'
elsif Rails.env == 'test'
  BUCKET_ENV = 'test'
elsif Rails.env == 'development'
  BUCKET_ENV = 'production'
end

Paperclip::Attachment.default_options.update({
  :path => ":class/:attachment/:id_partition/:style/:filename",
  :storage => :fog,
  :fog_credentials => {
    :provider => 'AWS',
    :aws_access_key_id => 'AKIAJGWG7DSPFB5UOV2Q',
    :aws_secret_access_key => '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',
    :region => 'eu-west-1',
  },
  :fog_directory => "sngtrkr-#{BUCKET_ENV}",
  :fog_public =>  true,
  :fog_host => "http://sngtrkr-#{BUCKET_ENV}.s3.amazonaws.com"
})