# COPY ALL OF ME INTO A FILE CALLED PRIVATE.RB
# PLACE FILE IN THE SAME DIRECTORY AS THIS EXAMPLE

SNGTRKR::Application.configure do

  # REPLACE WITH YOUR PERSONAL EMAIL LOGIN
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name             => 'bessey@gmail.com',
    :password             => '',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

end