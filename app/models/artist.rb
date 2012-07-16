class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases, :dependent => :delete_all


  belongs_to :label

  has_attached_file :image, :styles => {
    :large => "310x369#",
    :recommend => "202x178#",
    :manage => "100x100#",
    :friend_activity_artist => "87x87#",
    :friend_trkrs => "136x121#" }

  has_many :follow
  has_many :suggest
  has_many :manage

  has_many :followed_users, :through => :follow, :source => :user
  has_many :suggested_users, :through => :suggest, :source => :user
  has_many :manager_users, :through => :manage, :source => :user
  
  def self.real_only
    where(:ignore => false)
  end

  def real_releases
    self.releases.where(:ignore => false)
  end

  
  def self.ordered
    order('name')
  end
  
  def self.popularity 
    order('updated_at DESC')
  end

  before_save :default_values
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    true
  end

  def self.search(search)
    if search
      where("name LIKE ?","%#{search}%").page
    else
    self.page.all
    end
  end

  def managed?
    if(Manage.where("artist_id = ?",self.id).empty?)
    return false
    else
    return true
    end
  end

  def sdigital?
    sdid?
  end

  def followers
    Follow.where("artist_id = ?",self.id).count
  end

  def label?
    if(label_name? or label_id?)
    true
    else
    false
    end
  end

end
