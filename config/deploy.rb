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

#load 'deploy/assets'

# Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :deploy do
  task :ln_assets do
    run <<-CMD
      rm -rf #{latest_release}/public/assets &&
      mkdir -p #{shared_path}/assets &&
      ln -s #{shared_path}/assets #{latest_release}/public/assets
    CMD
  end

  task :assets do
    update_code
    ln_assets
    
    run_locally "rake assets:precompile"
    run_locally "cd public; tar -zcvf assets.tar.gz assets"
    top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
    run "cd #{shared_path}; tar -zxvf assets.tar.gz"
    run_locally "rm public/assets.tar.gz"
    run_locally "rm -rf public/assets/*.js public/assets/*.css"
    
    create_symlink
    restart
  end

end
