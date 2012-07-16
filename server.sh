killall -9 ruby
rails server -d
nohup sidekiq -q release,1 -q artist,2 -q artists,3 -c 2

