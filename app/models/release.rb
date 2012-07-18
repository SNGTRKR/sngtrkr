class Release < ActiveRecord::Base
  validates :name, :presence => true
  validates :date, :presence => true

  has_attached_file :image, :styles => { 
  :release_i => "310x311#",
  :release_carousel => "116x116#",
  :friend_activity_release => "87x87#" }


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
    self.artist.followed_users.each do |user|
      user.release_notifications << self
    end  
  end
  
  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  # SCRAPING METHODS
  @sevendigital_apikey = "7dufgm34849u"

  if Rails.env.production?
    @proxy = 'http://localhost:3128'
  else
    @proxy = nil
  end

  def self.daily_release
    Artist.where(:ignore => false).each do |artist|
      ReleaseJob.perform_async(artist.id)
    end
  end

  def self.sdigital_import artist
    if !artist.sdid?
      return false
    end
    releases = Hash.from_xml( open("http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB&imageSize=350", :proxy => @proxy))["response"]["releases"]["release"]
    if releases.blank?
      return false
    end

    releases.each do |release|
      begin
        if release["id"].blank? or !artist.releases.where("sd_id = ?",release["id"]).empty? 
          next
        end
      rescue
        Rails.logger.error "J004: A release for artist '#{artist.name}' failed"
        next
      end
      r = Release.new
      
      # Check for duplicate and skip if present
      existing_duplicates = artist.releases.where(:name => release["title"])
      if !existing_duplicates.empty?
        existing_duplicate = existing_duplicates.first
        # If the new release came out earlier, change the release date of the existing release in the DB.
        if existing_duplicate.date > release["releaseDate"]
          existing_duplicate.date = release["releaseDate"]
          existing_duplicate.save
        end
        next
      end

      # Seven Digital
      r.artist_id = artist.id
      r.sd_id = release["id"]
      r.name = release["title"]
      r.label_name = release["label"]["name"]
      r.date = release["releaseDate"]
      r.cat_no = release["isrc"]
      r.sdigital = release["url"]
      r.upc = release["barcode"]
      r.scraped = 1
      
      # iTunes UPC lookup
      itunes_release = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?upc=#{release["barcode"]}&country=GB", :proxy => @proxy))['results'][0]
      if !itunes_release.nil?
        r.itunes = itunes_release['collectionViewUrl']
      end
      
      Rails.logger.info("J003: Popularity of #{r.name} | #{release["popularity"]}")

      # Source the artwork from last.fm
      begin
        album_info = Scraper.lastfm_album_info(artist.name, r.name) 
        best_artwork = album_info['image'].last
      rescue
        best_artwork = nil
      end
      if best_artwork.is_a?(String)
        io = open(best_artwork, :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
      elsif release["image"]
        # Source the artwork from 7digital if last.fm don't have it.
        io = open(release["image"], :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
      end
      r.save


      # Now get the track ID's for preview URLS
      begin
        tracks = Hash.from_xml(open("http://api.7digital.com/1.2/release/tracks?releaseid=#{r.sd_id}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB", :proxy => @proxy))["response"]["tracks"]["track"]
      rescue
        Rails.logger.error("J003: Track scrape failed for release #{r.name} by #{artist.name}")
      end
      i = 1
      tracks.each do |track|
        begin
          if track["version"].blank?
            title = track["title"]
          else
          # Accounts for things like "Gold Dust (Netsky Remix)"
            track = "#{track["title"]} (#{track["version"]})"
          end
          t = Track.create(:release_id => r.id, :number => i, :name => title, :sd_id => track["id"])
          i = i+1
        rescue
          Rails.logger.error("J003: Individual track scrape failed for track: #{track.inspect}")
        end
      end
      
      # Get track previews from iTunes if you can't get them from 7digital
      if tracks.empty? and itunes_release
        Rails.logger.info("J007: Scraping tracks from iTunes for #{r.name}")
        i = 1
        itunes_release_tracks = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{itunes_release[0]['collectionId']}&entity=song&country=GB", :proxy => @proxy))['results']
        while !itunes_release_tracks[i].nil?
          t = Track.create(:release_id => r.id, :number => i, :name => itunes_release_tracks[i], :itunes_preview => itunes_release_tracks[i]['previewUrl'])
          i += 1
        end
      end
    end 
  end
    
  def self.itunes_import artist
    if artist.itunes_id?
      itunes_releases = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{artist.itunes_id}&entity=album&country=GB", :proxy => @proxy))['results']
      i = 1
      while !itunes_releases[i].nil?
        # Avoid importing the same album twice
        if !artist.releases.where("name LIKE ?", "%#{itunes_releases[i]['collectionName']}%").empty?
          i += 1
          next
        end
        r = Release.new
        Rails.logger.info("J004: new iTunes album found for #{artist.name} and #{itunes_releases[i]['collectionName']}")
        r.itunes = itunes_releases[i]['collectionViewUrl']
        r.artist_id = artist.id
        r.itunes_id = itunes_releases[i]["collectionId"]
        r.itunes = itunes_releases[i]['collectionViewUrl']
        r.name = itunes_releases[i]["collectionName"]
        r.date = itunes_releases[i]['releaseDate']
        r.scraped = 1
        
        album_info = Scraper.lastfm_album_info(artist.name, r.name)
        # If Last.fm doesn't have artwork for it, it's probably not
        # actually a real release! So skip to the next release
        begin
          best_artwork = album_info['image'].last 
        rescue
          i += 1
          next
        end

        if(!best_artwork.is_a?(String))
          raise "Artwork Error: Release: '#{r.name}'. Expected String, actually got: '#{best_artwork.inspect}'"
        end
        io = open(best_artwork, :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
        r.save
        i += 1
      end     
    end
  end


end
