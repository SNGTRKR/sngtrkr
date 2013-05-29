set :branch, 'master'
set :applicationdir, "/var/www/sngtrkr"
set :deploy_to, "/var/www/sngtrkr"

# Sidekiq
require "sidekiq/capistrano"

# Whenever for cron jobs
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

after "deploy:update_code", "solr:symlink"


# Generate an additional task to fire up the thin clusters
namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run "cd #{current_path} && bundle exec thin start -C thin.yml"
  end

  desc "Stop the Thin processes"
  task :stop do
    run "cd #{current_path} && bundle exec thin stop -C thin.yml"
  end

  desc "Restart the Thin processes"
  task :restart do
    run "cd #{current_path} && bundle exec thin restart -C thin.yml"
  end
end
