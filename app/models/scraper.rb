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

  def self.lastFmSearch search
    artist = Scrobbler::Artist.new(search)
    puts 'Top Tracks'
    puts "=" * 10
    artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
  end

  def self.importFbLikes access_token, user_id
    Resque.enqueue(ArtistJob,access_token,user_id)
  end

end