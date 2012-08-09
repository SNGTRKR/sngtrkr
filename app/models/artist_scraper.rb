class ArtistScraper

  @sevendigital_apikey = "7dufgm34849u"
  @proxy = Scraper.proxy
  @scraper
  @facebook_info
  require 'open-uri'

  def initialize opts={}
    @facebook_info = opts[:facebook_info]
    @user_id = opts[:user_id]
    @access_token = opts[:access_token]

  end

  def self.fb_single_import access_token, page_id, user_id
    graph = Koala::Facebook::API.new(access_token)
    artist = graph.api("/#{page_id}?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
    Rails.logger.info(artist)
    db_artist = import_info(access_token, user_id, artist)
    db_artist.save
    User.find(user_id).following << db_artist
    return db_artist
  end

  def image_url
    @image_url
  end

  def error_checks
    # Check artist isn't already in database
    if Artist.where(:fbid => @artist["id"]).count > 0
      puts "Tried to log an artist that is already in the database: '#{@artist["name"]}'"
      return false
    end

    begin
      if @artist["likes"] < 100
        puts "J002: Skipping #{@artist["name"]}, as they have only #{@artist["likes"]} likes"
        return false
      end
    rescue
      puts "J002: Failed, artist's like count could not be read."
    end

    begin
      @scraper = Scraper.new @artist["name"]
    rescue
    # Basically checks that we actually have a name for this artist.
      puts "J002: Failed, artist name could not be read."
      return false
    end

    if !@scraper.real_artist?
      # Skip artists that last.fm does not believe are real artists.
      puts "J002: Failed, last.fm did not believe '#{@artist["name"]}' is a real artist"
      return false
    end

    return true
  end

  def import_info
    if @scraper.nil?
      @scraper = Scraper.new @facebook_info["name"]
    end
    # Once we've covered the basic failing criteria, initialize variables (as late as possible)
    require 'open-uri'
    artist_start_time = Time.now

    split_regexp = /[,\/|+\.]/
    a = Artist.new
    a.name = @scraper.real_name
    a.fbid = @facebook_info["id"]
    a.bio = @scraper.bio
    if @scraper.bio.nil?
      a.bio = @facebook_info["bio"]
    end
    a.genre = @facebook_info["genre"].split(split_regexp).first rescue nil
    a.booking_email = @facebook_info["booking_agent"]
    a.manager_email = @facebook_info["general_manager"]
    a.hometown = @facebook_info["hometown"]
    a.label_name = @facebook_info["record_label"].split(split_regexp).first  rescue nil
    if(@facebook_info["website"])
      websites = @facebook_info["website"].split(' ')
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
    @image_url = @scraper.lastFmArtistImage

    return a
  end

  def save_image
    if @image_url and @image_url.is_a?(String)
      puts "Valid image: #{@image_url.inspect}"
      io = open(URI.escape(@image_url))
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      a.image = io
      end
    else
      puts "Invalid image: #{@image_url.inspect}"
    end    
  end

  def self.import access_token, user, artist

    if !error_checks artist
      return false
    end

    a = import_info(access_token, artist)
    save_image
    a.save!

    user.suggest_artist a.id
    if !a.sdid.nil?
      ReleaseJob.perform_async(a.id)
    end
    artist_end_time = Time.now
    artist_elapsed_time = artist_end_time - artist_start_time
    puts "New artist import finished after #{artist_elapsed_time}"
    return a
  end

end