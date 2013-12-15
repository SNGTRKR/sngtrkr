set :application, "sngtrkr"
set :user, "root"
set :scm, 'git'
set :repository, "https://github.com/SNGTRKR/sngtrkr.git"
set :scm_verbose, true
set :domain, '82.196.15.184'
set :applicationdir, "/var/www/sngtrkr"
set(:deploy_to) { applicationdir }

server domain, :app, :web, :db, :primary => true

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# Bundler for remote gem installs
require "bundler/capistrano"

require 'capistrano-unicorn'

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# deploy config
set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]
set :normalize_asset_timestamps, false
set :use_sudo, false

# additional settings
default_run_options[:pty] = true # Forgo errors when deploying from windows
default_run_options[:shell] = '/bin/bash --login'

namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
  end

  desc "stop solr"
  task :stop, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop"
  end

  desc "reindex the whole database"
  task :reindex, :roles => :app do
    run "cd #{current_path} && yes | RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end

  desc "Symlink in-progress deployment to a shared Solr index"
  task :symlink, :except => {:no_release => true} do
    run "ln -s #{shared_path}/solr/data/ #{release_path}/solr/data"
    run "ln -s #{shared_path}/solr/pids/ #{release_path}/solr/pids"
  end
end
namespace :configure do
  desc "Setup database configuration"
  task :database, :roles => :app do
    run "yes | cp /lib/configs/sngtrkr/database.yml /var/www/sngtrkr/current/config"
  end
  desc "Setup carrierwave configuration"
  task :carrierwave, :roles => :app do
      run "yes | cp /lib/configs/sngtrkr/carrierwave_config.rb /var/www/sngtrkr/current/config/initializers"
  end
  desc "Setup asset_sync configuration"
  task :asset_sync, :roles => :app do
    run "yes | cp /lib/configs/sngtrkr/asset_sync.rb /var/www/sngtrkr/current/config/initializers"
  end
  desc "Setup twitter configuration"
  task :twitter, :roles => :app do
    run "yes | cp /lib/configs/sngtrkr/twitter.rb /var/www/sngtrkr/current/config/initializers"
  end
  task :notify_rollbar, :roles => :app do
    set :revision, `git log -n 1 --pretty=format:"%H"`
    set :local_user, `whoami`
    set :rollbar_token, '3bd397eb03da4b5aa1a6afe77b0853db'
    rails_env = fetch(:rails_env, 'production')
    run "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{rollbar_token} -F environment=#{rails_env} -F revision=#{revision} -F local_username=#{local_user} >/dev/null 2>&1", :once => true
  end
end
namespace :assets do
    desc "Compile assets"
    task :compile, :roles => :app do
        run "cd /var/www/sngtrkr/current && RAILS_ENV=production RAILS_GROUPS=assets bundle exec rake assets:precompile"
    end
end

after :deploy, 'configure:carrierwave'
after 'configure:carrierwave', 'configure:asset_sync'
after 'configure:asset_sync', 'configure:database'
after 'configure:database', 'configure:twitter'
after 'configure:twitter' , 'solr:start'
after 'solr:start', 'solr:symlink'
after 'solr:symlink', 'assets:compile'
after 'assets:compile', 'configure:notify_rollbar'
after 'configure:notify_rollbar', 'unicorn:restart'
