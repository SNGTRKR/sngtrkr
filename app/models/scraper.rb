class Scraper
  include MusicBrainz

  # DOCS FOR ALL THE SCRAPING MODULES
  # Last.fm (Scrobbler) - http://scrobbler.rubyforge.org/docs/
  # MusicBrainz - http://rbrainz.rubyforge.org/api-0.5.2/
  # 7digital (Sevendigital) - https://github.com/filip7d/7digital

  def self.musicBrainzSearch search
    search = MusicBrainz::Webservice::ArtistFilter.new :name => search
    # Gets the top musicbrainz result
    artist = MusicBrainz::Webservice::Query.new.get_artists(search).to_collection[0]
  end

  def self.sevenDigitalSearch search
    sevendigital_apikey = "7dufgm34849u";
    xml =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/search?q=#{search}&sort=score%20desc&oauth_consumer_key=#{sevendigital_apikey}"))
    return xml["response"]["searchResults"]["searchResult"][0]
  end

  def self.lastFmSearch search
    artist = Scrobbler::Artist.new(search)

    puts 'Top Tracks'
    puts "=" * 10
    artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
  end

end