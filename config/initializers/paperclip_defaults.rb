if Rails.env == 'staging' or Rails.env == 'production'
  BUCKET_ENV = 'production'
elsif Rails.env == 'test'
  BUCKET_ENV = 'test'
elsif Rails.env == 'development'
  BUCKET_ENV = 'development'
end

Paperclip::Attachment.default_options.update({
  :path => ":class/:attachment/:id_partition/:style/:filename",
  :storage => :fog,
  :fog_credentials => {
    :provider => 'AWS',
    :aws_access_key_id => 'AKIAIEBWHRBGTD5XBYMA',
    :aws_secret_access_key => '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',
    :region => 'eu-west-1',
  },
  :fog_directory => "sngtrkr-#{BUCKET_ENV}",
  :fog_public =>  true
})