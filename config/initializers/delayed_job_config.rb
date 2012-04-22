# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
#Delayed::Worker.sleep_delay = 60
#Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 10.minutes
Delayed::Worker.max_attempts = 3
Delayed::Worker.sleep_delay = 60
