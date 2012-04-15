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
    xml =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/search?q=#{search}&sort=score%20desc&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB"))
    results = xml["response"]["searchResults"]["searchResult"]
    # Necessary to still return an ID when we have multiple artist possibilities (picks first artist)
    if results.kind_of?(Array)
    results = results[0]
    end
    id = results["artist"]["id"]
    releases =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/releases?artistId=#{id}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350"))
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
    return "Done"
  end
  
end