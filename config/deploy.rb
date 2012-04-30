set :default_environment, {
  'PATH' => "/home/ec2-user/.rvm/gems/ruby-1.9.3-p125/bin:/home/ec2-user/.rvm/gems/ruby-1.9.3-p125@global/bin:/home/ec2-user/.rvm/rubies/ruby-1.9.3-p125/bin:/home/ec2-user/.rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.3',
  'GEM_HOME'     => '/home/ec2-user/.rvm/gems/ruby-1.9.3-p125',
  'GEM_PATH'     => '/home/ec2-user/.rvm/gems/ruby-1.9.3-p125:/home/ec2-user/.rvm/gems/ruby-1.9.3-p125@global',
  'BUNDLE_PATH'  => '/home/ec2-user/.rvm/gems/ruby-1.9.3-p125@global/bin'  # If you are using bundler.
}

set :application, "sngtrkr_cap"
set :user, "ec2-user"
set :domain, 'sngtrkr.com'
set :applicationdir, "/var/www/apps/#{application}"

set :scm, 'git'
set :repository,  "ssh://ec2-user@sngtrkr.com/~/sngtrkr.git"
set :branch, 'master'
set :scm_verbose, true

role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"
require "bundler/capistrano"
#$:.unshift("#{ENV["HOME"]}/.rvm/lib")
set :rvm_type, :system  # Copy the exact line. I really mean :system here

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :remote_cache

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
#ssh_options[:keys] = '/Users/bessey/Dropbox/SNGTRKR/mattbillyhosts.pem'            
# If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false
 
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

#after "deploy:restart", "delayed_job:restart"

#after "deploy:symlink", "deploy:restart_workers"
#after "deploy:restart_workers", "deploy:restart_scheduler"

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
  desc "Restart Resque Workers"
  task :restart_workers, :roles => :db do
    run_remote_rake "resque:restart_workers"
  end

  desc "Restart Resque scheduler"
  task :restart_scheduler, :roles => :db do
    run_remote_rake "resque:restart_scheduler"
  end
end

=begin
namespace :delayed_job do 
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do
        run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
    end
    task :stop, :roles => :app do
        run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job stop"
    end
end
=end