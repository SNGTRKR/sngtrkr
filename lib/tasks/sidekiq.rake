namespace :sidekiq do
  desc "Stops and starts Sidekiq"
  task :restart do
  	`sidekiqctl stop tmp/pids/sidekiq.pid`
  	puts "Killed running workers."
  	`sidekiq --config config/sidekiq.yml -d --pidfile tmp/pids/sidekiq.pid -L log/sidekiq.log`
  	puts "Started new workers based on config/sidekiq.yml"
  end

end
