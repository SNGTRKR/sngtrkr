class Scraper
  include MusicBrainz
  
  @sevendigital_apikey = "7dufgm34849u"
  if Rails.env.production?
    @proxy = 'http://localhost:3128'
  else
    @proxy = nil
  end
  require 'open-uri'

  # DOCS FOR ALL THE SCRAPING MODULES
  # Last.fm (Scrobbler) - http://scrobbler.rubyforge.org/docs/
  # MusicBrainz - http://rbrainz.rubyforge.org/api-0.5.2/
  # 7digital -
  def self.musicBrainzSearch search
    search = MusicBrainz::Webservice::ArtistFilter.new :name => search
    # Gets the top musicbrainz result
    artist = MusicBrainz::Webservice::Query.new.get_artists(search).to_collection[0]
  end

  def self.new artist_name
    @artist_info = Hash.from_xml( open("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{CGI.escape(artist_name)}&api_key=6541dc514e866d40539bfe4eddde211c&autocorrect", :proxy => @proxy))
    @artist_name = artist_name
    self
  end
  
  def self.lastfm_album_info(artist_name, album_name)
    if artist_name.blank? or album_name.blank?
      raise "You have not specified an artist and album name"
    elsif !artist_name.is_a?(String) or !artist_name.is_a?(String)
      raise "Artist or album names are not strings: #{artist_name.inspect},  #{album_name.inspect}"
    end
    begin
      album_info = Hash.from_xml( open("http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=#{CGI.escape(artist_name)}&album=#{CGI.escape(album_name)}&api_key=6541dc514e866d40539bfe4eddde211c&autocorrect", :proxy => @proxy))
    rescue
      raise "URL Issue for artist_name: '#{artist_name}' and album-name: '#{album_name}'"
    end
    begin
      album_info = album_info['lfm']['album'] 
    rescue 
      return false # If there's an issue here, there were probably no results.
    end
    return album_info
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
      false
      else
      true
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

  def self.bio
    begin
    #ActionView::Helpers::SanitizeHelper.strip_tags(         )
      @artist_info["lfm"]["artist"]["bio"]["summary"].to_s
    rescue
    false
    end
  end

  def self.importFbLikes access_token, user_id
    Resque.enqueue(ArtistJob,access_token,user_id)
  end

  def self.artist_sevendigital artist_name
    xml =  Hash.from_xml open("http://api.7digital.com/1.2/artist/search?q=#{CGI.escape(artist_name)}&sort=score%20desc&oauth_consumer_key=#{@sevendigital_apikey}&country=GB", :proxy => @proxy)
    results = xml["response"]["searchResults"]["searchResult"]
    # Necessary to still return an ID when we have multiple artist possibilities (picks first artist)
    if results.kind_of?(Array)
    results = results[0]
    end
    begin
      id = results["artist"]["id"]
      url = results["artist"]["url"]
      return [id,url]
    rescue
      Rails.logger.error("7digital for ID of '#{artist_name}'")
      return nil
    end
  end
  
  def self.artist_7digital_search artist_name
    xml =  Hash.from_xml open("http://api.7digital.com/1.2/artist/search?q=#{CGI.escape(artist_name)}&sort=score%20desc&oauth_consumer_key=#{@sevendigital_apikey}&country=GB&imageSize=150", :proxy => @proxy)
    results = xml["response"]["searchResults"]["searchResult"]
    i = 0
    ret = Array.new
    while !results[i].nil? do
      ret[i] = { :score => results[i]['score'] }
      i += 1
    end
    return results
  end

  # Stores: 1 => itunes, 2 => 7digital, 3 => juno
  def self.find_release_info url, store
    require 'net/http'
    if store == 1
      itunes_regex = /(?<=\/id)([0-9]*)/
      id = itunes_regex.match url
      return ActiveSupport::JSON.decode(open("http://itunes.apple.com/lookup?ambAlbumId=#{id}"))
      
    end
    sd_artist_regex = /(?<=\/artist\/)([a-zA-Z0-9\-]*)/
    sd_release_regex = /(?<=\/release\/)([a-zA-Z0-9\-]*)/
    amazon_regex = /(?<=\/product\/)([a-zA-Z0-9\-]*)/

  # Will eventually take an iTunes / 7digital / Amazon url and get information on the release automatically.
  end

end