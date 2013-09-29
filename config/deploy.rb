set :application, "sngtrkr"
set :user, "vagrant"
set :scm, 'git'
set :repository, "https://github.com/SNGTRKR/sngtrkr.git"
set :scm_verbose, true
set :domain, '82.196.15.184'
set :applicationdir, "/home/vagrant/sngtrkr_rails_prod"
set(:deploy_to) { applicationdir }

server domain, :app, :web, :db, :primary => true

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# Bundler for remote gem installs
require "bundler/capistrano"

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# deploy config
set :deploy_via, :remote_cache

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

task :notify_rollbar, :roles => :app do
  set :revision, `git log -n 1 --pretty=format:"%H"`
  set :local_user, `whoami`
  set :rollbar_token, '3bd397eb03da4b5aa1a6afe77b0853db'
  rails_env = fetch(:rails_env, 'production')
  run "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{rollbar_token} -F environment=#{rails_env} -F revision=#{revision} -F local_username=#{local_user} >/dev/null 2>&1", :once => true
end

after :deploy , 'solr:start'
after 'solr:start', 'solr:reindex'
after 'solr:reindex', 'solr:symlink'
after 'solr:symlink', 'notify_rollbar'
