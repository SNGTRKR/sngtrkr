set :branch, 'staging'
set :applicationdir, "/var/www/sngtrkr"
set :deploy_to, "/var/www/sngtrkr"

# Sidekiq
require "sidekiq/capistrano"

# Whenever for cron jobs
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

after "deploy:update_code", "solr:symlink"


require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart' # app preloaded