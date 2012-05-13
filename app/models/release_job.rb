class ReleaseJob
  @queue = :releasejob
  @@sevendigital_apikey = "7dufgm34849u"
  def self.perform artist_id
    search = Artist.find(artist_id).name
    xml =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/search?q=#{URI.escape(search)}&sort=score%20desc&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB"))
    results = xml["response"]["searchResults"]["searchResult"]
    # Necessary to still return an ID when we have multiple artist possibilities (picks first artist)
    if results.kind_of?(Array)
    results = results[0]
    end
    begin
      id = results["artist"]["id"]
    rescue
      Logger.new(STDOUT).error("7digital scrape failed for release by '#{search}'")
    return false
    end
    begin
      releases =  Hash.from_xml( Net::HTTP.get( URI.parse(
      "http://api.7digital.com/1.2/artist/releases?artistId=#{id}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")))["response"]["releases"]["release"]
    rescue
      Logger.new(STDOUT).error("7digital scrape failed for release by '#{search}'")
    return false
    end
    releases.each do |release|
      r = Release.where("sd_id = ?",release["id"]).first
      if(r == [])
        r = Release.new
      end
      r.artist_id = artist_id
      r.sd_id = release["id"]
      r.name = release["title"]
      r.label_name = release["label"]["name"]
      r.date = release["releaseDate"]
      r.sdigital = release["url"]
      r.scraped = 1
      require 'open-uri'
      io = open(URI.escape(release["image"]))
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      r.image = io
      end

      r.save
    # r.rls_type = release["type"] # Single, Album

    end
  end
end
