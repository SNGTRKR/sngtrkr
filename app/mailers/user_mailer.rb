class UserMailer < ActionMailer::Base
  default from: "noreply@sngtrkr.com"
  ses = AWS::SES::Base.new(
  :access_key_id     => ENV['AMAZON_ACCESS_KEY'],
  :secret_access_key => ENV['AMAZON_SECRET_KEY']
  )
  def welcome_email(user)
    ses.addresses.verify(user.email)
    mail(:to => user.email, :subject => "Welcome to SNGTRKR!")
  end
end
