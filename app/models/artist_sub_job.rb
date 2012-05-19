class ArtistSubJob
  @queue = :artistsubjob
  @@sevendigital_apikey = "7dufgm34849u"
  def self.perform artist, user_id, access_token
    start_time = Time.now
    require 'open-uri'
    graph = Koala::Facebook::API.new(access_token)
    begin
      s = Scraper.new artist["name"]
    rescue
    # Basically checks that we actually have a name for this artist.
      Rails.logger.error "J002: Failed, artist name could not be read."
    return false
    end
    if !s.real_artist?
      # Skip artists that last.fm does not believe are real artists.
      Rails.logger.error "J002: Failed, last.fm did not believe '#{a.name}' is a real artist"
    return false
    end
    #a = Artist.new()
    a = Artist.where("fbid = ?",artist["id"]).first
    if a.nil?
      a = Artist.new()
    elsif Rails.env.production?
      Rails.logger.error "J002: Failed, artist #{a.name} appears to already be in the database"
    return false
    end
    split_regexp = /[,\/|+\.]/
    a.name = s.real_name
    a.fbid = artist["id"]
    a.bio = s.bio
    if s.bio.nil?
      a.bio = artist["bio"]
    end
    a.genre = artist["genre"].split(split_regexp).first rescue nil
    a.booking_email = artist["booking_agent"]
    a.manager_email = artist["general_manager"]
    a.hometown = artist["hometown"]
    a.label_name = artist["record_label"].split(split_regexp).first  rescue nil
    if(artist["website"])
      websites = artist["website"].split(' ')
    else
    websites = [];
    end
    itunes = ItunesSearch::Base.new
    begin
      a.itunes = itunes.search("term"=>a.name, "country" => "gb").results.first.artistViewUrl
    rescue
      a.itunes = nil
    end
    sd_info = Scraper.artist_sevendigital a.name
    if !sd_info.nil?
    a.sdid = sd_info[0]
    a.sd = sd_info[1]
    end
    websites.each do |website|
      if(website.length < 5)
      next
      end
      if(website =~ /(?<=twitter\.com\/)(#!\/)?(.*)/)
      a.twitter = $&
      elsif(website =~ /(?<=youtube\.com\/)(#!\/)?(.*)/)
      a.youtube = $&
      elsif(website =~ /(?<=soundcloud\.com\/)(#!\/)?(.*)/)
      a.soundcloud = $&
      else
      a.website = website
      end
    end
    image = s.lastFmArtistImage
    if image != false
      io = open(URI.escape(image))
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      a.image = io
      end
    end
    a.save
    Rails.logger.error "J002: Artist #{a.name} successfully imported"
    User.find(user_id).suggest_artist a.id
    if !a.sdid.nil?
      #    Resque.enqueue(ReleaseJob, a.id)
      artist = a

      require 'open-uri'
      begin
        releases = Hash.from_xml( open( URI.parse("http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")))["response"]["releases"]["release"]
      rescue
        Rails.logger.error("J003: 7digital scrape failed ~ #{artist.sdid}")
      return false
      end
      releases.each do |release|
        r = Release.where("sd_id = ?",release["id"]).first rescue next
        if r.nil?
          r = Release.new
        elsif Rails.env.production? or !IMPORT_REPLACE
        Rails.logger.notice("J003: 7digital scrape stopped, release appear to already be in database for artist #{artist.name}")
        next
        end

        r.artist_id = artist.id
        r.sd_id = release["id"]
        r.name = release["title"]
        r.label_name = release["label"]["name"]
        r.date = release["releaseDate"]
        r.sdigital = release["url"]
        r.scraped = 1
        io = open(URI.escape(release["image"]))
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io
        r.image = io
        end
        r.save
      end
      end_time = Time.now
      elapsed_time = end_time - start_time
      Rails.logger.info "J003: Release import for #{artist.name} finished after #{elapsed_time}"
    return true
    end
  end
end