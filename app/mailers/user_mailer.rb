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
  
  def new_releases(frequency)
    #frequency_enum = {:instant => 0, :daily => 1, :weekly => 2, :fortnightly => 3, :monthly => 4}
    User.where(:email_frequency => frequency).each do |user|
      @user = user
      @releases = user.release_notifications
      if @releases.empty?
        next
      end
      case frequency
        when 1 then @freq_word = "Daily"
        when 2 then @freq_word = "Weekly"
        when 3 then @freq_word = "Fortnightly"
        when 4 then @freq_word = "Monthly"
      end
      mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", :subject => "SNGTRKR | #{@freq_word} Update").deliver
      user.release_notifications.destroy_all
    end
  end
  
  def daily_releases
    new_releases(1)
  end

  def weekly_releases
    new_releases(2)
  end
  
  def fortnightly_releases
    new_releases(3)
  end

  def monthly_releases
    new_releases(4)
  end
  
  def instant_release(release)
    
  end

end
