class Release < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true

  has_attached_file :image, :styles => { 
  :medium => "300x300>", 
  :thumb => "100x100>",
  :release => "210x210#" }

  has_many :tracks
  has_many :notification
  has_many :user_notifications, :through => :notification, :source => :user
  belongs_to :artist
  
  after_create :notify_followers

  # Notify users that follow this release's artist of this release.
  def notify_followers
    self.artist.followed_users.each do |user|
      user.release_notifications << release
    end  
  end

end
