set :application, "sngtrkr"
set :user, "deploy"
set :domain, 'sngtrkr.com'
set :applicationdir, "/var/www/#{application}"

set :scm, 'git'
set :repository,  "ssh://deploy@sngtrkr.com/~/sngtrkr.git"
set :branch, 'master'
set :scm_verbose, true

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true        # This is where Rails migrations will run

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# Bundler for remote gem installs
require "bundler/capistrano"
# Whenever for cron jobs
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
# Load RVM's capistrano plugin.   
#require "rvm/capistrano"

# Sidekiq
#require "sidekiq/capistrano"

#set :rvm_ruby_string, '1.9.3'
#set :rvm_type, :user  # Copy the exact line. I really mean :system here

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
 
set :synchronous_connect, true

# Passenger
namespace :deploy do
  task :start do 
    run ""
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Paperclip regeneration
namespace :deploy do
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

