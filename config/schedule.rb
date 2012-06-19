every 1.day, :at => '1:00 am' do 
  runner "UserMailer.daily_email"
end

every 1.day, :at => '1:00 pm' do 
  runner "Cron.daily_release"
end