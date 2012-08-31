
set :output, '/var/log/sngtrkr/schedule.log'

every 1.day, :at => '9:00 am' do 
  runner "UserMailer.daily_releases"
end

every 7.days, :at => '10:00 am' do 
  runner "UserMailer.weekly_releases"
end

every 14.days, :at => '11:00 am' do 
  runner "UserMailer.fortnightly_releases"
end

every 1.month, :at => '12:00 am' do 
  runner "UserMailer.monthly_releases"
end

every 1.day, :at => '8:00 am' do 
  runner "ReleaseScraper.daily_release"
end
