class Scraper
  include MusicBrainz
  @@sevendigital_apikey = "7dufgm34849u";
  # DOCS FOR ALL THE SCRAPING MODULES
  # Last.fm (Scrobbler) - http://scrobbler.rubyforge.org/docs/
  # MusicBrainz - http://rbrainz.rubyforge.org/api-0.5.2/
  # 7digital -
  def self.musicBrainzSearch search
    search = MusicBrainz::Webservice::ArtistFilter.new :name => search
    # Gets the top musicbrainz result
    artist = MusicBrainz::Webservice::Query.new.get_artists(search).to_collection[0]
  end

  def self.getReleases search
    require 'resque'
    Resque.enqueue(SevenDigital, :releases, :search => search)
    return true
  end

  def self.lastFmSearch search
    artist = Scrobbler::Artist.new(search)
    puts 'Top Tracks'
    puts "=" * 10
    artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
  end

  def self.importFbLikes access_token
    # TODO: pass in user id as well for suggestions 
    require 'resque'
    Resque.enqueue(FbJob,access_token)
    return true
  end
  
end