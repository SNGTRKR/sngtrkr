killall -9 ruby
rails server -d
rake resque:restart_workers
