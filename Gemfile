source 'http://rubygems.org'

gem 'rails', '~> 4'
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-action_caching'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'

# VERSION AND DEPLOYMENT
group :production do
  gem 'unicorn'
  gem 'therubyracer'
  gem 'rollbar', '~> 0.9.6'
  gem 'newrelic_rpm'
  gem 'sitemap_generator', :require => false
  gem 'whenever', :require => false
end

gem 'mysql2'

group :test do
  gem 'rspec-rails'
  gem 'rake'
  gem 'capybara'
  gem 'sunspot-rails-tester'
end

group :test, :development do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'pry'
end

# CACHING
gem 'dalli'

# MAILER
gem 'maktoub'

# BACKGROUND TASKS
gem 'sidekiq', :require => false
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'fog'
gem 'mini_magick'
gem "carrierwave"

# SCRAPING GEMS
gem 'scrobbler'
gem 'itunes-search-api', github: 'bessey/itunes-search-api', branch: 'multi-lookup'

# ADMIN
gem 'custom_configuration'

group :development do
  gem 'mail_view', "~> 2"
  gem 'capistrano', "~> 2"
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request' #, '0.2.1'
  gem 'capistrano-unicorn', :require => false
  # gem 'rack-mini-profiler'
  gem 'ruby-prof'
end

gem 'sass-rails', '~> 4'
gem 'compass-rails', "~> 2.0.alpha.0"
gem 'coffee-script'
gem 'font-awesome-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer'

gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'

#gem 'client_side_validations', :github => 'bcardarella/client_side_validations', :branch => '3-2-stable'
# Authentication
gem 'devise', '~> 3.2'
gem 'cancan'

# Facebook
gem "koala"
gem "omniauth-facebook"

# Twitter
gem 'twitter'

# URL Shortener
gem 'shortener'

gem 'kaminari'

gem 'sunspot_rails' #, :git => "git://github.com/mkrisher/sunspot.git", :branch => "task_warning_bypass"
gem 'sunspot_solr'
