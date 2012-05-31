class UserMailer < ActionMailer::Base
  default from: "SNGTRKR <noreply@sngtrkr.com>"
  def welcome_email(user)
    @user = user # For the view
    mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", :subject => "Welcome to SNGTRKR!")
  end
  def beta_email(user)
    @user = user # For the view
    mail(:to => "#{@user.email}", :subject => "Welcome to the SNGTRKR beta!")
  end
  def daily_email
    User.all.each do |user|
      @user = user 
      mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", :subject => "SNGTRKR | Daily Update")
    end
  end

end
