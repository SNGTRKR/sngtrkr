# Trucker is the SNGTRKR mail daemon. He was created to remove the logic from 
# UserMailer, which was in charge of too much stuff.
class Trucker

  def self.daily_releases
    new_releases_deliver 1
  end

  def self.weekly_releases
    new_releases_deliver 2
  end

  def self.fortnightly_releases
    new_releases_deliver 3
  end

  def self.monthly_releases
    new_releases_deliver 4
  end

  def self.deliver_new_releases_email user
    releases = user.release_notifications.current.with_artist.all
    return false if releases.empty?
    artist_names = user.release_notifications.artist_names

    m = UserMailer.new_releases_email(user, artist_names, releases)
    m.deliver

    mark_notifications_sent(user, releases)
  end

  private

  def self.new_releases_deliver frequency
    User.where(email_frequency: frequency).each do |user|
      deliver_new_releases_email user
    end
  end

  def self.mark_notifications_sent user, releases
    releases.each do |r|
      rn = Notification.find(r.notification_id)
      rn.sent = true
      rn.sent_at = Time.now
      rn.save!
    end
  end

end