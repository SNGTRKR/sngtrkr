class UserMailer < ActionMailer::Base
  default from: "bessey@gmail.com"
  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to SNGTRKR!")
  end
end
