set :branch, 'staging'
set :applicationdir, "/var/www/sngtrkr_staging"
set :deploy_to, "/var/www/sngtrkr_staging"

require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart' # app preloaded