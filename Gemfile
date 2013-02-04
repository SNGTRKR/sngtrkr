source 'https://rubygems.org'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'
gem 'ajaxful_rating', "~> 3.0.0.beta8"
gem "best_in_place"

# VERSION AND DEPLOYMENT
group :production do
  gem 'passenger'
  gem 'therubyracer'
end
gem 'sitemap_generator'

gem 'mysql2'

group :test do
  gem 'rspec-rails'
end

gem 'capistrano'
# gem 'rvm-capistrano'  -- THIS MUST BE INSTALLED LOCALLY, IT WILL NOT WORK IN A GEMFILE.

# BACKGROUND TASKS
gem 'sidekiq'
gem 'whenever', :require => false

gem 'fog'
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
  gem 'sass-rails',   '>= 3.2.3'
  gem 'compass-rails', '>= 1.0.0.rc.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
end

gem 'jquery_datepicker'

gem "koala"

# Authentication
gem 'devise'
gem 'cancan'
gem "omniauth-facebook"

gem 'kaminari'


