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

  def self.lastFmArtistImage search
    search = URI.encode(search)
    artist = Hash.from_xml( Net::HTTP.get( URI.parse("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{search}&api_key=6541dc514e866d40539bfe4eddde211c")))
    begin
      image = artist["lfm"]["artist"]["image"].last
      Rails.logger.info "Last.fm artist image for #{artist.name} - #{image}"
      if image.instance_of(Hash)
      return false
      end
    rescue
    return false
    end
  end

  def self.importFbLikes access_token, user_id
    Resque.enqueue(ArtistJob,access_token,user_id)
  end

end