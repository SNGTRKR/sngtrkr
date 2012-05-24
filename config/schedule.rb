every 1.day, :at => '3:40 pm' do 
  runner "UserMailer.daily_email"
end