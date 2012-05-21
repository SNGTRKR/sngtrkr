# To sign your request, include AWS_secret_key. 
Amazon::Ecs.options = {
  :associate_tag => 's055-21',
  :AWS_access_key_id => ENV['MATT_AMAZON_ACCESS_KEY'],       
  :AWS_secret_key => ENV['MATT_AMAZON_SECRET_KEY']
}