class SevenDigital
  @queue = :seven_digital;
  @@sevendigital_apikey = "7dufgm34849u";
  
  def self.perform mode
    if(mode == :releases)
      search = params[:search]
      xml =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/search?q=#{search}&sort=score%20desc&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB"))
      results = xml["response"]["searchResults"]["searchResult"]
      # Necessary to still return an ID when we have multiple artist possibilities (picks first artist)
      if results.kind_of?(Array)
      results = results[0]
      end
      id = results["artist"]["id"]
      releases =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/releases?artistId=#{id}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350"))
      # TODO actually add the releases to the database with :scraped => 1
    elsif(mode == :purchase_url)
      # TODO get 7digital purchase URL for given release
      # params => [:release_name, :artist_name]
    else
      error "Unrecognised mode. Mode must be :search or :purchase_url"
    end
    
  end
end
