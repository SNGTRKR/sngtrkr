task :server => :environment do
  puts 'start unicorn development'
  sh "cd #{Rails.root} && RAILS_ENV=development unicorn -c config/unicorn.rb -D"
end
# an alias task
task :s => :server