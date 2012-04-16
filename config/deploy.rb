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
role :db,  domain, :primary => true # This is where Rails migrations will run

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
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#TODO replace with http://www.bencurtis.com/2011/12/skipping-asset-compilation-with-capistrano/

# Pinched from cap's own recipe
_cset :asset_env, "RAILS_GROUPS=assets"
_cset :assets_prefix, "assets"
_cset :assets_role, [:web]

_cset :normalize_asset_timestamps, false
namespace :deploy do
  namespace :assets do
    task :symlink, :roles => assets_role, :except => { :no_release => true } do
      run <<-CMD
        rm -rf #{latest_release}/public/#{assets_prefix} &&
        mkdir -p #{latest_release}/public &&
        mkdir -p #{shared_path}/assets &&
        ln -s #{shared_path}/assets #{latest_release}/public/#{assets_prefix}
      CMD
    end

    task :precompile, :roles => assets_role, :except => { :no_release => true } do
      run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
    end

    task :clean, :roles => assets_role, :except => { :no_release => true } do
      run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:clean"
    end
    symlink
    precompile
  end
end