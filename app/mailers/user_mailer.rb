class UserMailer < ActionMailer::Base
  default from: "SNGTRKR <noreply@sngtrkr.com>"
  @@ses = AWS::SES::Base.new(
  :access_key_id     => ENV['AMAZON_ACCESS_KEY'],
  :secret_access_key => ENV['AMAZON_SECRET_KEY']
  )
  def welcome_email(user)
    @user = user # For the view
    # Verify users we don't have permission to email already
    if !@@ses.addresses.list.result.include? user.email
      @@ses.verify user.email
      Rails.logger.notice "E001: Verifying email address #{user.email}"
    else
      mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", :subject => "Welcome to SNGTRKR!")
    end
  end
end
