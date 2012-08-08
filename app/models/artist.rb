class Artist < ActiveRecord::Base
  validates :name, :presence => true
  validates :fbid, :presence => true, :uniqueness => true

  has_many :releases, :dependent => :delete_all

  belongs_to :label

  has_attached_file :image, :styles => {
    :profile => "310x369#",
    :recommend => "212x178#",
    :manage => "100x100#",
    :sidebar_suggest => "50x50#"
     }

  has_many :follow, :dependent => :destroy
  has_many :suggest, :dependent => :destroy
  has_many :manage, :dependent => :destroy

  has_many :followed_users, :through => :follow, :source => :user
  has_many :suggested_users, :through => :suggest, :source => :user
  has_many :manager_users, :through => :manage, :source => :user
  
  def self.real_only
    where(:ignore => false)
  end

  def real_releases
    self.releases.where("ignore != ?", true)
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


  def self.fb_single_import access_token, page_id, user_id
    graph = Koala::Facebook::API.new(access_token)
    artist = graph.api("/#{page_id}?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
    Rails.logger.info(artist)
    db_artist = import(access_token, user_id, artist)
    User.find(user_id).following << db_artist
    return db_artist
  end

  def self.import access_token, user_id, artist
    # Check artist isn't already in database
    if Artist.where(:fbid => artist["id"]).count > 0
      Rails.logger.info "Tried to log an artist that is already in the database: '#{artist["name"]}'"
      return true
    end
    begin
      if artist["likes"] < 100
        Rails.logger.info "J002: Skipping #{artist["name"]}, as they have only #{artist["likes"]} likes"
      return false
      end
    rescue
      Rails.logger.error "J002: Failed, artist's like count could not be read."
    end
    begin
      s = Scraper.new artist["name"]
    rescue
    # Basically checks that we actually have a name for this artist.
      Rails.logger.error "J002: Failed, artist name could not be read."
    return false
    end
    if !s.real_artist?
      # Skip artists that last.fm does not believe are real artists.
      Rails.logger.error "J002: Failed, last.fm did not believe '#{artist["name"]}' is a real artist"
    return false
    end

    # Once we've covered the basic failing criteria, initialize variables (as late as possible)
    user = User.find(user_id)
    graph = Koala::Facebook::API.new(access_token)
    require 'open-uri'
    artist_start_time = Time.now

    split_regexp = /[,\/|+\.]/
    a = Artist.new
    a.name = s.real_name
    a.fbid = artist["id"]
    a.bio = s.bio
    if s.bio.nil?
      a.bio = artist["bio"]
    end
    a.genre = artist["genre"].split(split_regexp).first rescue nil
    a.booking_email = artist["booking_agent"]
    a.manager_email = artist["general_manager"]
    a.hometown = artist["hometown"]
    a.label_name = artist["record_label"].split(split_regexp).first  rescue nil
    if(artist["website"])
      websites = artist["website"].split(' ')
    else
    websites = [];
    end
    begin
      itunes_results = ITunesSearchAPI.search(:term => a.name, :country => "GB").first
      a.itunes = itunes_results['artistViewUrl']
      a.itunes_id = itunes_results['artistId']
    rescue
      a.itunes = nil
    end
    sd_info = Scraper.artist_sevendigital a.name
    if !sd_info.nil?
    a.sdid = sd_info[0]
    a.sd = sd_info[1]
    end
    websites.each do |website|
      if(website.length < 5)
      next
      end
      if(website =~ /(?<=twitter\.com\/)(#!\/)?(.*)/)
      a.twitter = $&
      elsif(website =~ /(?<=youtube\.com\/)(#!\/)?(.*)/)
      a.youtube = $&
      elsif(website =~ /(?<=soundcloud\.com\/)(#!\/)?(.*)/)
      a.soundcloud = $&
      else
      a.website = website
      end
    end
    image = s.lastFmArtistImage
    if image and image.is_a?(String)
      Rails.logger.warn "Valid image: #{image.inspect}"
      io = open(URI.escape(image))
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      a.image = io
      end
    else
      Rails.logger.warn "Invalid image: #{image.inspect}"
    end
    a.save
    user.suggest_artist a.id
    if !a.sdid.nil?
      ReleaseJob.perform_async(a.id)
    end
    artist_end_time = Time.now
    artist_elapsed_time = artist_end_time - artist_start_time
    Rails.logger.info "J002: New artist import finished after #{artist_elapsed_time}"
    return a
  end
    

end
