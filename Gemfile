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

group :development do
  gem 'sqlite3'
end


gem 'capistrano'
# gem 'rvm-capistrano'  -- THIS MUST BE INSTALLED LOCALLY, IT WILL NOT WORK IN A GEMFILE.

# BACKGROUND TASKS
gem 'resque'

# SCRAPING GEMS
gem 'rbrainz'
gem "paperclip", "~> 3.0"
gem 'scrobbler'
gem 'itunes-search'

# ADMIN
#gem 'rails_admin'


# in production environments by default.
group :assets do
  gem 'sass-rails',   '>= 3.2.3'
  gem 'compass-rails', '>= 1.0.0.rc.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'fancybox-rails'

gem "koala", "~> 1.4.0"
gem 'devise'
gem "omniauth-facebook"

gem 'will_paginate', '~> 3.0.beta'

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
