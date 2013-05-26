set :application, "sngtrkr"
set :user, "deploy"
set :scm, 'git'
set :repository,  "https://github.com/SNGTRKR/sngtrkr.git"
set :scm_verbose, true
set :domain, 'sngtrkr.com'
set :applicationdir, "/var/www/sngtrkr"
set(:deploy_to) { applicationdir }
set :rvm_ruby_string, "2.0"
set :rvm_type, :user

role(:web) { domain }                          # Your HTTP server, Apache/etc
role(:app) { domain }                          # This may be the same as your `Web` server
role(:db, :primary => true) { domain }        # This is where Rails migrations will run

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

# Bundler for remote gem installs
require "rvm/capistrano"
require "bundler/capistrano"

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# deploy config
set :deploy_via, :remote_cache

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
 
namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
  end

  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop"
  end

  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data/*"
    start
    puts "You need to run this yourself now:"
    puts "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end

  desc "Symlink in-progress deployment to a shared Solr index"
  task :symlink, :except => { :no_release => true } do
    run "ln -s #{shared_path}/solr/data/ #{release_path}/solr/data"
    run "ln -s #{shared_path}/solr/pids/ #{release_path}/solr/pids"
  end
end
