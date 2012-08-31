class Release < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true
  validates :artist_id, :presence => true

  has_attached_file :image, :styles => { 
  :release_i => "310x311#",
  :release_carousel => "116x116#",
  :activity_release => "40x40#" }


  has_many :tracks, :dependent => :delete_all
  has_many :notification, :dependent => :delete_all
  has_many :user_notifications, :through => :notification, :source => :user
  belongs_to :artist
  
  ajaxful_rateable :stars => 5, :allow_update => true, :dependent => :destroy
  
  after_create :notify_followers

  before_save :default_values
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    self.scraped ||= false
    true
  end

  # Notify users that follow this release's artist of this release.
  def notify_followers
    if self.date > (Date.today - 14)
      self.artist.followed_users.each do |user|
        user.release_notifications << self
      end  
    end
  end
  
  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  def itunes
    if itunes?
      return "http://clk.tradedoubler.com/click?p=23708&a=2098473&url=#{CGI.escape(super)}"
    else
      return nil
    end
  end

end
