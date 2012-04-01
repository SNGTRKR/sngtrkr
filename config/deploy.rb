# The name of your app
set :application, "sngtrkr"
# The directory on the EC2 node that will be deployed to
set :deploy_to, "/var/www/apps/#{application}"
# The type of Source Code Management system you are using
set :scm, :git
# The location of the LOCAL repository relative to the current app
#set :repository,  "."
#set :deploy_via, :copy

#=begin
set :repository,  "ssh://ec2-user@sngtrkr.com/~/sngtrkr.git"
#set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
ssh_options[:forward_agent] = true
set :deploy_via, :export
#=end

# The way in which files will be transferred from repository to remote host
# If you were using a hosted github repository this would be slightly different

# The address of the remote host on EC2 (the Public DNS address)
set :location, "sngtrkr.com"
# setup some Capistrano roles
role :app, location
role :web, location
role :db,  location, :primary => true

# Set up SSH so it can connect to the EC2 node - assumes your SSH key is in ~/.ssh/id_rsa
set :user, "ec2-user"
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
set :synchronous_connect, true

before "deploy:assets:precompile", "bundle:install"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

