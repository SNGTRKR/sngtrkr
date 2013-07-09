class UserMailer < ActionMailer::Base

  default from: "SNGTRKR <noreply@sngtrkr.com>"

  def welcome_email(user)
    @user = user # For the view
    mail(:to => "#{@user.email}", :subject => "Welcome to SNGTRKR")
  end

  def new_releases_email(user, artist_names, releases)
    @user = user
    @releases = releases

    case @user.email_frequency
      when 1
        @date_adjective = "daily"
      when 2
        @date_adjective = "weekly"
      when 3
        @date_adjective = "fortnightly"
      when 4
        @date_adjective = "monthly"
    end
  
    mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>",
         :subject => "#{@date_adjective.humanize} Update | New releases from #{artist_names}",
         :from => "SNGTRKR Update <noreply@sngtrkr.com>")
  end

  class Preview
    def welcome_email
      r = Role.create(:name => 'Admin')
      user = User.new(:id => '29', :first_name => 'Billy', :last_name => 'Dallimore', :fbid => "660815460", :email => "tom.alan.dallimore@googlemail.com", :password => 'test42343egysfdf', :last_sign_in_at => Time.now,
                      :email_frequency => 1)
      user.roles = [r]
      user.skip_confirmation!
      user.save
      mail = UserMailer.welcome_email(user)
      user.destroy
      mail
    end
  end

end
