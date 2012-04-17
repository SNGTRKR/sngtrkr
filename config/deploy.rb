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

#TODO add restarting / starting of resque workers.
#TODO add starting of resque server.

load "deploy/assets"

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
  #run "cd #{latest_release} && #{rake} queue:restart_workers RAILS_ENV=production"
end

namespace :deploy do
  desc "Hot-reload God configuration for the Resque worker"
  task :reload_god_config do
    sudo "god stop resque"
    sudo "god load #{File.join(deploy_to, 'current', 'config', 'resque-' + rails_env + '.god')}"
    sudo "god start resque"
  end
end

# append to the bottom:

after :deploy, "deploy:reload_god_config"
