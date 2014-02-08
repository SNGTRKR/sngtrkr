source 'http://rubygems.org'

# Core
gem 'rails', '~> 4'
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-action_caching'
gem 'actionpack-page_caching'
gem 'mysql2'
gem 'json'

# Version and deployment
group :production do
  gem 'rollbar'
  gem 'newrelic_rpm'
  gem 'sitemap_generator', :require => false
  gem 'whenever', :require => false
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'pg'
end

group :test, :development do
  gem 'pry'
end

group :development do
  gem 'capistrano', '~> 2.15'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request' #, '0.2.1'
  gem 'quiet_assets'
  gem 'haml-rails'
  gem 'rack-mini-profiler'
  gem 'ruby-prof'
  gem 'bullet'
  gem 'haml'
  gem 'metric_fu'
end

# Mac only
platform :ruby do
  group :production do
    gem 'unicorn'
    gem 'therubyracer'
  end
  group :development do
    gem 'capistrano-unicorn', :require => false
  end
end

# Caching
gem 'dalli'

# Mailer
gem 'maktoub'
gem 'rails_email_preview'

# Background tasks
gem 'sidekiq', :require => false
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

# Image management
gem 'fog'
gem 'mini_magick'
gem 'carrierwave'
gem 'unf'

# SCRAPING GEMS
gem 'scrobbler'
gem 'itunes-search-api', github: 'bessey/itunes-search-api', branch: 'multi-lookup'

# ADMIN
gem 'custom_configuration'

# Assets
gem 'sass-rails', '~> 4'
gem 'compass-rails'
gem 'coffee-rails'
gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'
gem 'asset_sync'


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

# Pagination
gem 'kaminari'

# Global variables
gem 'global'

gem 'sunspot_solr', github: 'sunspot/sunspot', branch: 'master'
gem 'sunspot_rails', github: 'sunspot/sunspot', branch: 'master'
