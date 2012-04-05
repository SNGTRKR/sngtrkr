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

  def self.importFbLikes accesstoken
    graph = Koala::Facebook::API.new(accesstoken)
    music = graph.get_connections("me", "music")
    i = 0
    beginning_time = Time.now

    Koala::Facebook::BatchOperation.instance_variable_set(:@identifier, 0)
    results = graph.batch do |batch_api|
      music.each do |artist|
        if(i == 50)
        break
        end
        batch_api.get_object(artist["id"])
        i=i+1
      end
    end

    end_time = Time.now
    results.each do |artist|
      a = Artist.new()
      a.name = artist["name"]
      a.fbid = artist["id"]
      details = graph.get_object(artist["id"])
      a.bio = details["bio"]
      a.genre = details["genre"]
      a.booking_email = details["booking_agent"]
      a.manager_email = details["general_manager"]
      a.hometown = details["hometown"]
      a.website = details["website"]
      a.save
    end

    return results
  end

end