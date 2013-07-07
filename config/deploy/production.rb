set :branch, 'staging'
set :applicationdir, "/home/vagrant/sngtrkr_rails_prod"
set :deploy_to, "/home/vagrant/sngtrkr_rails_prod"

# Sidekiq
require "sidekiq/capistrano"

# Whenever for cron jobs
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

after "deploy:update_code", "solr:symlink"


require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart' # app preloaded