class UserMailer < ActionMailer::Base
  
  default from: "SNGTRKR <noreply@sngtrkr.com>"
  
  def welcome_email(user)
    @user = user # For the view
    mail(:to => "#{@user.email}", :subject => "Welcome to SNGTRKR!")
  end
  
  def new_releases_deliver(frequency)
    User.where(:email_frequency => frequency).each do |user|
      new_releases(user,:deliver => true)
    end
  end

  def new_releases(user,opts={:deliver => false})
    @user = user
    frequency = @user.email_frequency

    conditions = ["releases.date < ? and notifications.sent = ?",Date.today+1, false]

    @releases = user.release_notifications.order("date DESC").where(conditions).limit(20)
    
    notifications = user.notifications.all(:include => [:release], :conditions => conditions, :limit => 20, :order => "date DESC")
    if @releases.empty?
      return false
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

    m = mail(:to => "#{@user.first_name} #{@user.last_name} <#{@user.email}>", 
      :subject => "#{@date_adjective} Update | New releases from #{artist_names}",
      :from => "SNGTRKR Update <noreply@sngtrkr.com>")
    if opts[:deliver]
      m.deliver
    end
    notifications.each do |n|
      n.mark_as_sent!
    end

    return m

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
