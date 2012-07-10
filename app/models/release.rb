class Release < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true

  has_attached_file :image, :styles => { 
  :medium => "300x300>", 
  :thumb => "100x100>",
  :release => "210x210#",
  :release_i => "310x311#",
  :release_email => "84x84#",
  :release_carousel => "116x116#",
  :friend_activity_release => "87x87#" }
  #:default_url => "/images/release/:style/missing.png"


  has_many :tracks, :dependent => :delete_all
  has_many :notification, :dependent => :delete_all
  has_many :user_notifications, :through => :notification, :source => :user
  belongs_to :artist
  
  ajaxful_rateable :stars => 5, :allow_update => true
  
  after_create :notify_followers

  # Notify users that follow this release's artist of this release.
  def notify_followers
    self.artist.followed_users.each do |user|
      user.release_notifications << self
    end  
  end
  
  def pretty_date
    date.strftime('%d/%m/%Y')
  end

end
