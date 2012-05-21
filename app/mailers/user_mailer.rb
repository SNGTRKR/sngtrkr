class UserMailer < ActionMailer::Base
  default from: "noreply@sngtrkr.com"
  ses = AWS::SES::Base.new()
  def welcome_email(user)
    mail(:to => user.email, :subject => "Welcome to SNGTRKR!") rescue Rails.logger.error("Welcome Email Failed to Send")
  end
end
