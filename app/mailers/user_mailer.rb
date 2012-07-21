class UserMailer < ActionMailer::Base
  default from: "SNGTRKR <noreply@sngtrkr.com>"
  def welcome_email(user)
    @user = user # For the view
    mail(:to => "#{@user.email}", :subject => "The wait is finally over...")
  end
  
  def beta_email(user)
    @user = user # For the view
    mail(:to => "#{@user.email}", :subject => "Welcome to the SNGTRKR Beta!")
  end
  
  def new_releases_deliver(frequency)
    User.where(:email_frequency => frequency).each do |user|
      new_releases(user,frequency)
    end
  end

  def new_releases(user,frequency)
    @user = user

    @releases = user.release_notifications

    if ENV['TEST_MODE']
      puts("Test mode active.")
      @releases = Release.limit(22)
    end

    if @releases.empty?
      return true
    end
    case frequency
      when 1 then @date_adjective = "Daily"
      when 2 then @date_adjective = "Weekly"
      when 3 then @date_adjective = "Fortnightly"
      when 4 then @date_adjective = "Monthly"
    end
    
    if @releases.count > 20
      @many_releases = true
      @releases_count = @releases.count
      @releases = @releases[0,20]
    end

    # Building list of artist names for the email subject
    artist_names = @releases.select('DISTINCT artist_id')[0,2].collect{|r| r.artist.name}.join(', ')
    
    mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", 
      :subject => "#{@date_adjective} Update | New releases from #{artist_names}").deliver
    user.release_notifications.destroy_all
    return true

  end
  
  def daily_releases
    new_releases_deliver(1)
  end

  def weekly_releases
    new_releases_deliver(2)
  end
  
  def fortnightly_releases
    new_releases_deliver(3)
  end

  def monthly_releases
    new_releases_deliver(4)
  end
  
  def instant_release(release)
    
  end

end
