set :branch, 'staging'
set :applicationdir, "/home/vagrant/sngtrkr_rails_prod"
set :deploy_to, "/home/vagrant/sngtrkr_rails_prod"

require 'capistrano-unicorn'

after 'deploy:restart', 'unicorn:restart' # app preloaded