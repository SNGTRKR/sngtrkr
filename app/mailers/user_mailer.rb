class UserMailer < ActionMailer::Base
  default from: "SNGTRKR <noreply@sngtrkr.com>"
  def welcome_email(user)
    @user = user # For the view
    # Verify users we don't have permission to email already
    # No longer needed as we've been authorized.
    # if !@@ses.addresses.list.result.include? user.email
    #  @@ses.verify user.email
    #  Rails.logger.notice "E001: Verifying email address #{user.email}"
    # else
    mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", :subject => "Welcome to SNGTRKR!")
    # end
  end
  def daily_email
    User.all.each do |user|
      @user = user 
      mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", :subject => "SNGTRKR | Daily Update")
    end
  end

end
