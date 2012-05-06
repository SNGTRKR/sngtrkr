class Scraper
  include MusicBrainz
  @@sevendigital_apikey = "7dufgm34849u"
  # DOCS FOR ALL THE SCRAPING MODULES
  # Last.fm (Scrobbler) - http://scrobbler.rubyforge.org/docs/
  # MusicBrainz - http://rbrainz.rubyforge.org/api-0.5.2/
  # 7digital -
  def self.musicBrainzSearch search
    search = MusicBrainz::Webservice::ArtistFilter.new :name => search
    # Gets the top musicbrainz result
    artist = MusicBrainz::Webservice::Query.new.get_artists(search).to_collection[0]
  end

  # Fetches an artist on 7digital and adds all their releases to the database.
  def self.getReleases artist_id
    Resque.enqueue(ReleaseJob, artist_id)
  end

  def self.new artist_name
    search = URI.encode artist_name
    @artist_info = Hash.from_xml( Net::HTTP.get( URI.parse("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{search}&api_key=6541dc514e866d40539bfe4eddde211c&autocorrect")))
    @artist_name = artist_name
    self
  end

  def self.lastFmArtistImage
    begin
      image = @artist_info["lfm"]["artist"]["image"].last
      if !image.is_a? String
      return false
      end
      return image
    rescue
    return false
    end
  end

  def self.real_artist?
    begin
      if @artist_info["lfm"]["artist"]["bio"]["summary"] =~ /is not an artist/
      true
      else
      false
      end
    rescue
    false
    end
  end

  def self.real_name
    begin
      @artist_info["lfm"]["artist"]["name"]
    rescue
    @artist_name
    end
  end

  def self.importFbLikes access_token, user_id
    Resque.enqueue(ArtistJob,access_token,user_id)
  end

end