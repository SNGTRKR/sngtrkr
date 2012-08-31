class UserMailer < ActionMailer::Base
  
  default from: "SNGTRKR <noreply@sngtrkr.com>"
  
  def welcome_email(user)
    @user = user # For the view
    mail(:to => "#{@user.email}", :subject => "The wait is finally over...").deliver
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

    @releases = user.release_notifications.order("date DESC").where("date < ?",Date.today+1).limit(20)
    if @releases.empty?
      return true
    end

    # Building list of artist names for the email subject
    artist_names = @releases.select('DISTINCT artist_id')[0,2].collect{|r| r.artist.name}.join(', ')

    case frequency
      when 1 then @date_adjective = "Daily"
      when 2 then @date_adjective = "Weekly"
      when 3 then @date_adjective = "Fortnightly"
      when 4 then @date_adjective = "Monthly"
    end
    
    total_count = user.release_notifications.where("date < ?",Date.today+1).count
    if total_count > 20
      @many_releases = true
      @releases_count = total_count
    end

    if Rails.env.development?
      @domain = "http://localhost:3000"
    else
      @domain = "http://sngtrkr.com"
    end

    mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", 
      :subject => "#{@date_adjective} Update | New releases from #{artist_names}",
      :from => "SNGTRKR Update <noreply@sngtrkr.com>").deliver
    user.release_notifications.delete(@releases)

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

 class Preview < MailView
    # Pull data from existing fixtures
    def new_releases
      user = User.where(:fbid => 123456789).first
      user.release_notifications = Release.limit(100).order("date DESC")
      frequency = 1
      ::UserMailer.new_releases(user,frequency)
    end
    def welcome_email
      ::UserMailer.welcome_email(User.first)
    end
    def beta_email
      ::UserMailer.beta_email(User.first)
    end
  end

end
