every 1.day, :at => '3:47 pm' do 
  runner "UserMailer.daily_email"
end