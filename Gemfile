source 'https://rubygems.org'

gem 'rails', '~> 3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'
gem "best_in_place"

# VERSION AND DEPLOYMENT
group :production do
  gem 'unicorn'
  gem 'therubyracer'
end

gem 'sitemap_generator', :require => false
gem 'newrelic_rpm'
gem 'mysql2'

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
  gem 'rake'
end

gem 'capistrano'
gem 'rvm-capistrano'

# CACHING
gem 'dalli'

# MAILER
gem 'rails_email_preview'

# BACKGROUND TASKS
gem 'sidekiq', :require => false
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'whenever', :require => false

gem 'fog'
gem 'mini_magick'
gem "carrierwave"

# SCRAPING GEMS
gem 'scrobbler'
gem 'itunes-search-api'

# ADMIN
gem 'rails_admin'
gem 'exception_notification', :require => 'exception_notifier'

# DEBUGGING

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request' #, '0.2.1'
  gem 'pry'
  gem 'capistrano-unicorn', :require => false
end

group :assets do
  # in production environments by default.
  gem 'sass-rails',   '>= 3.2.3'
  gem 'compass-rails', '>= 1.0.0.rc.2'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'turbo-sprockets-rails3'
end

gem 'client_side_validations', :github => 'bcardarella/client_side_validations', :branch => '3-2-stable'
# Authentication
gem 'devise'
gem 'cancan'

# Facebook
gem "koala"
gem "omniauth-facebook"

gem 'kaminari'

gem 'sunspot_rails' #, :git => "git://github.com/mkrisher/sunspot.git", :branch => "task_warning_bypass"
gem 'sunspot_solr' #, :git => "git://github.com/mkrisher/sunspot.git", :branch => "task_warning_bypass"

