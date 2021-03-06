# Should be 'production' by default, otherwise use other env 
rails_env = ENV['RAILS_ENV'] || 'production'

# Set your full path to application.
app_path = "/var/www/sngtrkr"

# Set unicorn options
worker_processes 1
preload_app true
timeout 180
listen "#{app_path}/shared/sockets/unicorn.sock", :backlog => 64
#listen "127.0.0.1:9000"

# Fill path to your app
working_directory "#{app_path}/current"


# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Set master PID location
pid "#{app_path}/shared/pids/unicorn.pid"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  NewRelic::Agent.shutdown
  ActiveRecord::Base.establish_connection
end