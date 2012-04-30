class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases
  belongs_to :label

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  has_many :follow
  has_many :suggest
  has_many :manage

  has_many :followed_users, :through => :follow, :source => :user
  has_many :suggested_users, :through => :suggest, :source => :user
  has_many :manager_users, :through => :manage, :source => :user

  before_save :default_values
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    true
  end

  def self.search(search)
    if search
      find(:all, :conditions => ["name LIKE '%%#{search}%%'"])
    else
      self.all
    end
  end

  def managed?
    if(Manage.find(:all, :conditions => ["artist_id = #{self.id}"]).empty?)
    return false
    else
    return true
    end
  end

  def followers
    Follow.find(:all, :conditions => ["artist_id = #{self.id}"]).count
  end

end
