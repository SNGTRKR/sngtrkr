class Release < ActiveRecord::Base
  require 'open-uri'
  validates :name, :presence => true
  validates :date, :presence => true
  validates :artist_id, :presence => true

  mount_uploader :image, ReleaseUploader

  has_many :notification, :dependent => :destroy
  has_many :user_notifications, :through => :notification, :source => :user
  belongs_to :artist

  if !Rails.env.test?
    searchable :auto_index => true, :auto_remove => true do
      text :name, :boost => 2.0, :as => :code_textp
      text :artist_name, :as => :code_textp do
        artist.try(:name)
      end
      text :label_name
    end
  end 

  def to_s
    self.name
  end
  
  after_create :notify_followers

  scope :unsaved_images, where('(image_file_name is null or image_file_name = "") and image_source is not null and image_source != ""')

  before_save :default_values
  before_save :metadata_cleanup
  after_save :combine_duplicates


  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    self.scraped ||= false
    self.image_attempts ||= 0
    true
  end

  def metadata_cleanup
    # Gets rid of (Featuring X) / (Feat X.) / (feat x) / [feat x]
    feat = / (\(|\[)(f|F)eat[^\)]*(\)|\])/
    ep = /( - |- | )?(\(|\[)?(EP|(S|s)ingle|(A|a)lbum)(\)|\])?/
    itunes_remix = /(\(|\[)(R|r)emixes(\)|\])/
    ret = name.gsub( name.match(feat).to_s, "")
    ret = ret.gsub( ret.match(itunes_remix).to_s, "")
    ret = ret.gsub( ret.match(ep).to_s, "")
    self.name = ret.strip # Remove whitespace at either end

    true
  end

  def combine_duplicates
    window = 7.days
    existing = self.artist.releases.where('date between ? AND ? AND id != ? AND name = ?',
      self.date - window, self.date + window, self.id, self.name)

    unless existing.empty?
      existing.each do |r|
        self.itunes ||= r.itunes
        self.sdigital ||= r.sdigital
        self.amazon ||= r.amazon
        self.itunes_id ||= r.itunes_id
        self.sd_id ||= r.sd_id
      end
      existing.destroy_all
    end
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

  def self.save_scraped_images
    Release.unsaved_images.each do |r|
      # Attempts to save an image with exponential backoff
      if !r.image_file_name and r.image_source
        if !r.image_last_attempt or (r.image_last_attempt + (2^r.image_attempts).hour) > Time.now
          puts "Would be saving" + r.image_source
          r.image_attempts = r.image_attempts ? r.image_attempts += 1 : 0
          r.image_last_attempt = Time.now

          io = open(r.image_source)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end

          r.save
        end
      end
    end
  end

  def self.download_missing_images
    Release.includes(:artist).where('image_file_name is null or image_file_name = ""').order('created_at DESC').limit(500).each do |r|
      if r.image_last_attempt and (r.image_last_attempt + (2^r.image_attempts).hour) > Time.now
        next
      end
      r.image_attempts = r.image_attempts ? r.image_attempts += 1 : 0
      r.image_last_attempt = Time.now
      artist_name = r.artist.try(:name)
      if artist_name.nil? then next end
      album_info = Scraper.lastfm_album_info(r.artist.name, r.name)
      if album_info and album_info['image'].is_a? Array
        best_artwork = album_info['image'].last
        if best_artwork and best_artwork.is_a?(String)
          io = open(best_artwork)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end 
        end
      end
      r.save      
    end
  end

  def self.twitter_update
    @trel = Release.order("date").last
    @tart = Artist.find(@trel.artist_id)
    if Rails.env.development?
      @tdomain = "http://dev.sngtrkr.com:3000"
    else
      @tdomain = "http://sngtrkr.com"
    end
    if @tart.genre?
      @tgenre = "##{@tart.genre}"
    end
    @turl = Shortener::ShortenedUrl.generate("#{@tdomain}/artists/#{@tart.id}/releases/#{@trel.id}")
    Twitter.update("#{@tart.name} - #{@trel.name}, released #{@trel.date.strftime("#{@trel.date.day.ordinalize} %B %Y ")} #{@tdomain}/#{@turl.unique_key}")
  end

end
