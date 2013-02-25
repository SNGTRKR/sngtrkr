set :application, "sngtrkr"
set :user, "deploy"
set :domain, 'sngtrkr.com'
set :staging_domain, 'staging.sngtrkr.com'
set :scm, 'git'
set :repository,  "https://github.com/MattBessey/sngtrkr.git"
set :scm_verbose, true

desc "Run tasks in staging enviroment."
task :production do

  set :applicationdir, "/var/www/sngtrkr"
  set :deploy_to, applicationdir
  set :branch, 'master'
  role :web, domain                          # Your HTTP server, Apache/etc
  role :app, domain                          # This may be the same as your `Web` server
  role :db,  domain, :primary => true        # This is where Rails migrations will run

  # Sidekiq
  require "sidekiq/capistrano"

  # Whenever for cron jobs
  set :whenever_command, "bundle exec whenever"
  require "whenever/capistrano"

end

desc "Run tasks in staging enviroment."
task :staging do
  set :applicationdir, "/var/www/sngtrkr_staging"
  set :deploy_to, applicationdir
  set :branch, 'staging'
  role :web, domain
  role :app, domain
  role :db, domain, :primary=>true

  namespace :deploy do
    namespace :assets do
      task :precompile do 
        puts "No asset precompilation in staging, baws!"
      end
    end
  end
end



# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# Bundler for remote gem installs
require "bundler/capistrano"
# Load RVM's capistrano plugin.   
require "rvm/capistrano"

# deploy config
set :deploy_via, :remote_cache

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
 
# set :synchronous_connect, true

namespace :deploy do
  # Passenger
  task :start do 
    run ""
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"

  end

  # Paperclip regeneration
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
  end 
end

#after("deploy:update_code", "deploy:build_missing_paperclip_styles")

##
# Rake helper task.
# http://pastie.org/255489
# http://geminstallthat.wordpress.com/2008/01/27/rake-tasks-through-capistrano/
# http://ananelson.com/said/on/2007/12/30/remote-rake-tasks-with-capistrano/
def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end


namespace :deploy do
  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end
end
 
namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end
 
after 'deploy:setup', 'deploy:setup_solr_data_dir'
