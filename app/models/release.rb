class Release < ActiveRecord::Base
  require 'open-uri'
  validates :name, :presence => true
  validates :date, :presence => true
  validates :artist_id, :presence => true

  mount_uploader :image, ReleaseUploader, mount_on: :image_file_name

  has_many :notifications, :dependent => :destroy
  has_many :user_notifications, :through => :notifications, :source => :user
  belongs_to :artist

  if Rails.configuration.x.solr.enable_indexing
    searchable do
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
  scope :latest_missing_images, includes(:artist).where('image_file_name is null or image_file_name = ""').order('created_at DESC')

  scope :with_artist, -> {includes(:artist)}

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
    deluxe_edition = /(\(|\[)Deluxe (Edition|Version)(\)|\])/
    self.name.gsub!(self.name.match(feat).to_s, "")
    self.name.gsub!(self.name.match(itunes_remix).to_s, "")
    self.name.gsub!(self.name.match(ep).to_s, "")
    self.name.gsub!(self.name.match(deluxe_edition).to_s, "")
    self.name.strip! # Remove whitespace at either end

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

  def itunes(original=false)
    if original
      return super()
    elsif itunes?
      return "http://clk.tradedoubler.com/click?p=23708&a=2098473&url=#{CGI.escape(super())}"
    else
      return nil
    end
  end

  def self.twitter_update
    @trel = Release.where(:tweet => nil).order("date DESC").first
    @tart = Artist.find(@trel.artist_id)
    if Rails.env.development?
      @tdomain = "http://dev.sngtrkr.com:3000"
    else
      @tdomain = "http://sngtrkr.com"
    end
    @turl = "#{@tdomain}/artists/#{@tart.id}/releases/#{@trel.id}"
    Twitter.update("#{@tart.name} - #{@trel.name}, released #{@trel.date.strftime("#{@trel.date.day.ordinalize} %B %Y ")} #{@turl}")
    @trel.update_attribute(:tweet, true)
  end

end
