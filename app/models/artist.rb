class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases, :dependent => :destroy

  belongs_to :label

  has_attached_file :image, :styles => {
      :profile => ["310x369#"],
      :recommend => ["212x178#"],
      :manage => ["100x100#"],
      :sidebar_suggest => ["50x50#"],
      :original => ["800x800>"]
    }, 
    :convert_options => {
      :all => '-quality 40 -strip' ,
    },
    :fog_public => true

  has_many :follow, :dependent => :delete_all
  has_many :suggest, :dependent => :delete_all
  has_many :manage, :dependent => :delete_all

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

  def self.popular
    if Rails.env.production?
      count = 5
    else
      count = 1
    end
    artists_with_followers = Artist.find(:all, :select => 'artists.*, count(follows.id) as follow_count',
             :joins => 'left outer join follows on follows.artist_id = artists.id',
             :group => 'artists.id',
             :having => "follow_count >= #{count}")
  end
  
  def self.popularity 
    order('updated_at DESC')
  end

  def itunes
    if itunes?
      return "http://clk.tradedoubler.com/click?p=23708&a=2098473&url=#{CGI.escape(super)}"
    else
      return nil
    end
  end

  before_save :default_values
  before_save :delete_children_for_ignored
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    true
  end

  def delete_children_for_ignored
    if self.ignore
      self.follow.destroy_all
      self.suggest.destroy_all
    end
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
