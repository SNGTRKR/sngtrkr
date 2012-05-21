class UserMailer < ActionMailer::Base
  default from: "noreply@sngtrkr.com"
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to SNGTRKR!")
  end
end
