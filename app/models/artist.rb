class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true
  attr_accessor :prospective_image

  has_many :releases, :dependent => :destroy

  belongs_to :label

  mount_uploader :image, ArtistUploader, mount_on: :image_file_name

  has_many :follows, :dependent => :delete_all
  has_many :suggests, :dependent => :delete_all

  has_many :followed_users, :through => :follows, :source => :user
  has_many :suggested_users, :through => :suggests, :source => :user

  if Rails.configuration.x.solr.enable_indexing
    searchable do
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
    Rails.cache.fetch("releases/release-#{id}", :expires_in => 1.hour) do
      real_releases.all(:order => 'date DESC', :limit => 15)
    end
  end

  # Load artist releases upon tracking a new artist on the timeline, limiting to 5 most recent
  def timeline_releases
    real_releases.order('date DESC').limit(5)
  end

  def count_release
    Rails.cache.fetch("release_count/release-#{id}", :expires_in => 1.hour) do
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

    Artist.select('artists.*, count(follows.id) as follow_count').joins(:follow).group("follows.artist_id").having("follow_count > 2").order("follow_count DESC").limit(5)
  end

  def self.popularity
    order('updated_at DESC')
  end

  def itunes(original=false)
    if itunes?
      if original
        return super() # Non optional brackets get rid of the original argument
      else
        return "http://clk.tradedoubler.com/click?p=23708&a=2098473&url=#{CGI.escape(super())}"
      end
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
      self.follows.destroy_all
      self.suggests.destroy_all
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
    follows.count
  end

  def label?
    if (label_name? or label_id?)
      true
    else
      false
    end
  end

  # TEMP METHOD: Assign songkick IDs to current artists in the database
  # def songkick_artist
  #   Artist.all.each do |artist|
  #     artist_result = JSON.parse("http://api.songkick.com/api/3.0/search/artists.json?query=#{artist.name}&apikey=#{request.env['SONGKICK_API_KEY']}")
  #     artist.songkick_id = artist_result["id"]
  #     artist.save!
  #   end
  # end

  # def songkick_events
  #   events = JSON.parse("http://api.songkick.com/api/3.0/artists/#{songkick_id}/calendar.json?apikey={request.env['SONGKICK_API_KEY']}")
  #   return events
  # end

end
