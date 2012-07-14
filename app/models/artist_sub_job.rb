class ArtistSubJob
  @queue = :artistsubjob
  @@sevendigital_apikey = "7dufgm34849u"
  
  def self.single_import access_token, page_id, user_id
    graph = Koala::Facebook::API.new(access_token)
    artist = graph.api("/#{page_id}?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
    Rails.logger.info(artist)
    db_artist = self.perform(access_token, user_id, artist)
    User.find(user_id).following << db_artist
    return db_artist
  end
  
  def self.perform access_token, user_id, artist
    begin
      if artist["likes"] < 100
        Rails.logger.info "J002: Skipping #{artist["name"]}, as they have only #{artist["likes"]} likes"
      return false
      end
    rescue
      Rails.logger.error "J002: Failed, artist's like count could not be read."
    end
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

    # Once we've covered the basic failing criteria, initialize variables (as late as possible)
    user = User.find(user_id)
    graph = Koala::Facebook::API.new(access_token)
    require 'open-uri'
    artist_start_time = Time.now

    split_regexp = /[,\/|+\.]/
    a = Artist.new
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
    begin
      itunes_results = ITunesSearchAPI.search(:term => a.name, :country => "GB").first
      a.itunes = itunes_results['artistViewUrl']
      a.itunes_id = itunes_results['artistId']
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
    if image
      io = open(URI.escape(image))
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      a.image = io
      end
    end
    a.save!
    user.suggest_artist a.id
    if !a.sdid.nil?
      Resque.enqueue(ReleaseJob, a.id)
    end
    artist_end_time = Time.now
    artist_elapsed_time = artist_end_time - artist_start_time
    Rails.logger.info "J002: New artist import finished after #{artist_elapsed_time}"
    return a
  end
end