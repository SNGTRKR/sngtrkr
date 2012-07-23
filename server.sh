killall -9 ruby
rails server -d
sidekiq -q release,1 -q artist,2 -q artists,3 -c 2

