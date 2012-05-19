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
      Rails.logger.error "J002: Failed, last.fm did not believe '#{artist["name"]}' is a real artist"
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
    User.find(user_id).suggest_artist a.id
    if !a.sdid.nil?
      Resque.enqueue(ReleaseJob, a.id)
    end
    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J002: Release import for #{artist.name} finished after #{elapsed_time}"
  end
end