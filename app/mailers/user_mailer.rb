class UserMailer < ActionMailer::Base
  default from: "noreply@sngtrkr.com"
  def welcome_email(user)
    ses = AWS::SES::Base.new(
    :access_key_id     => ENV['AMAZON_ACCESS_KEY'],
    :secret_access_key => ENV['AMAZON_SECRET_KEY']
    )
    ses.addresses.verify(user.email)
    mail(:to => user.email, :subject => "Welcome to SNGTRKR!")
  end
end
