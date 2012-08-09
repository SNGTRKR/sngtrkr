source 'https://rubygems.org'

gem 'rails', '3.2.2'

# JS
group :production do
  gem 'therubyracer'
end
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'
gem 'ajaxful_rating', "~> 3.0.0.beta8"
gem "best_in_place"

# VERSION AND DEPLOYMENT
group :production do
  gem 'mysql2'
  gem 'passenger'
end

group :development, :test do
  gem 'sqlite3'
  gem 'seed_dumper'
end

group :test do
  gem 'ruby-prof'
end

gem 'capistrano'
# gem 'rvm-capistrano'  -- THIS MUST BE INSTALLED LOCALLY, IT WILL NOT WORK IN A GEMFILE.

# BACKGROUND TASKS
gem 'sidekiq'
gem 'whenever', :require => false

# SIDEKIQ MONITORING
gem 'slim'
gem 'sinatra', :require => nil

gem "paperclip"

# SCRAPING GEMS
# gem 'rbrainz'
gem 'scrobbler'
gem 'itunes-search-api'
gem 'amazon-ecs'

# ADMIN
gem 'rails_admin'
gem "exception_notification", :git => "http://github.com/rails/exception_notification.git", :branch => "master", :require => 'exception_notifier'
gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'


group :assets do
  # in production environments by default.
  gem 'compass-rails', '>= 1.0.0.rc.2'
  gem 'sass-rails',   '>= 3.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'bootstrap-sass', '~> 2.0.4.0'
end

gem 'jquery_datepicker'

gem "koala"

# Authentication
gem 'devise'
gem 'cancan'
gem "omniauth-facebook"

gem 'kaminari'

gem 'dynamic_sitemaps'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
