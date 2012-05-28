source 'https://rubygems.org'

gem 'rails', '3.2.2'

# JS
group :production do
  gem 'therubyracer'
end
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'

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
gem 'redis'
gem 'resque'
gem 'whenever', :require => false

gem "paperclip", "~> 3.0"

# SCRAPING GEMS
gem 'rbrainz'
gem 'scrobbler'
gem 'itunes-search'
gem 'amazon-ecs'

# ADMIN
gem 'rails_admin'

# in production environments by default.
gem 'compass-rails', '>= 1.0.0.rc.2'
group :assets do
  gem 'sass-rails',   '>= 3.2.3'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery_datepicker'

gem "koala", "~> 1.4.0"

# Authentication
gem 'devise'
gem 'cancan'
gem "omniauth-facebook"

gem 'kaminari'

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
