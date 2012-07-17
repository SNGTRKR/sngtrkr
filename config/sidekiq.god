rails_env = ENV['RAILS_ENV'] || "production"
rails_root = ENV['RAILS_ROOT'] || "/var/www/sngtrkr/current"

God.watch do |w|
  w.dir      = "#{rails_root}"
  w.name     = "sidekiq"
  w.interval = 30.seconds
  w.env      = {"RAILS_ENV" => rails_env}
  w.interval = 30.seconds
  w.start = "bundle exec sidekiq -q release,1 -q artist,2 -q artists,3 -c 20"


  w.uid = 'deploy'

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end