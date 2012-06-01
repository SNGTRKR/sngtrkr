# Start a worker with proper env vars and output redirection
require 'resque/tasks'

#task "resque:setup" do
#  raise "Please set your RESQUE_WORKER variable to true" unless ENV['RESQUE_WORKER'] == "true"
#  root_path = "#{File.dirname(__FILE__)}/../.."
#  require "#{root_path}/app/artist_job.rb"
#  require "#{root_path}/app/artist_sub_job.rb"
#  require "#{root_path}/app/release_job.rb"
#end

if Rails.env.development?
  @workers = 1
else
  @workers = 3
end

def run_worker(queue, count = 1)
  puts "Starting #{count} worker(s) with QUEUE: #{queue}"
  ops = {:pgroup => true, :err => [(Rails.root + "log/workers_error.log").to_s, "a"], 
                          :out => [(Rails.root + "log/workers.log").to_s, "a"]}
  env_vars = {"QUEUE" => queue.to_s}
  count.times {
    ## Using Kernel.spawn and Process.detach because regular system() call would
    ## cause the processes to quit when capistrano finishes
    pid = spawn(env_vars, "rake resque:work", ops)
    Process.detach(pid)
  }
end

namespace :resque do
  task :setup => :environment

  desc "Restart running workers"
  task :restart_workers => :environment do
    Rake::Task['resque:stop_workers'].invoke
    Rake::Task['resque:start_workers'].invoke
  end
  
  desc "Quit running workers"
  task :stop_workers => :environment do
    pids = Array.new
    Resque.workers.each do |worker|
      pids.concat(worker.worker_pids)
    end
    if pids.empty?
      puts "No workers to kill"
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "Running syscmd: #{syscmd}"
      system(syscmd)
    end
  end
  
  desc "Start workers"
  task :start_workers => :environment do
    run_worker("artistjob,artistsubjob,releasejob", @workers)
  end

end