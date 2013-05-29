class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases, :dependent => :destroy

  belongs_to :label

  mount_uploader :image, ArtistUploader, mount_on: :image_file_name

  has_many :follow, :dependent => :delete_all
  has_many :suggest, :dependent => :delete_all

  has_many :followed_users, :through => :follow, :source => :user
  has_many :suggested_users, :through => :suggest, :source => :user

  if !Rails.env.test?
    searchable :auto_index => true, :auto_remove => true do
      text :name, :boost => 2.0, :as => :code_textp
      text :label_name
      boolean :ignore
    end
  end

  def to_s
    self.name
  end

  def self.real_only
    where(:ignore => false)
  end

  def real_releases
    self.releases.includes(:artist).where(:ignore => false)
  end

  # caching related releases on release page. either updated in 1 hour or via an updated_at attribute change
  def related_releases
    Rails.cache.fetch("releases/#{id}-#{updated_at}", :expires_in => 1.hour) do
      real_releases.all(:order => 'date DESC', :limit => 15)
    end
  end

  def count_release
    Rails.cache.fetch("release_count/#{id}-#{updated_at}", :expires_in => 1.hour) do
      releases.count
    end
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
    # Crap and slow
    # Removed as :all is deprecated in rails 3.2
    #Artist.find.all( :select => 'artists.*',
    #            :joins => 'left outer join follows on follows.artist_id = artists.id',
    #            :group => 'artists.id',
    #            :having => "count(follows.id) >= #{count}",
    #            :limit => 5)
    Artist.select('artists.*, count(follows.id) as follow_count').joins(:follow).group("follows.artist_id").having("follow_count > 2").order("follow_count DESC").limit(5)
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

  def managed?
    if (Manage.where("artist_id = ?", self.id).empty?)
      return false
    else
      return true
    end
  end

  def sdigital?
    sdid?
  end

  def followers
    Follow.where("artist_id = ?", self.id).count
  end

  def label?
    if (label_name? or label_id?)
      true
    else
      false
    end
  end

end
