set :branch, 'staging'
set :applicationdir, "/var/www/sngtrkr"
set :deploy_to, "/var/www/sngtrkr"

require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart' # app preloaded