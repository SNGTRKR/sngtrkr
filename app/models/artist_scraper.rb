class ArtistScraper
  attr_accessor :image_url, :artist

  @sevendigital_apikey = "7dufgm34849u"
  @proxy = Scraper.proxy

  require 'open-uri'

  def initialize opts={}
    @start_time = Time.now
    if !opts[:facebook_info]
      raise "ArtistScraper ERROR: No artist information given"
    end
    @facebook_info = opts[:facebook_info]
    if opts[:user_id]
      @user = User.find(opts[:user_id])
    end
    if opts[:access_token]
      @access_token = opts[:access_token]
    end

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

  def error_checks
    # Check artist isn't already in database
    if Artist.where(:fbid => @facebook_info["id"]).count > 0
      puts "Tried to log an artist that is already in the database: '#{@facebook_info["name"]}'"
      return false
    end

    begin
      if @facebook_info["likes"] < 100
        puts "J002: Skipping #{@facebook_info["name"]}, as they have only #{@facebook_info["likes"]} likes"
        return false
      end
    rescue
      puts "J002: Failed, artist's like count could not be read."
    end

    begin
      @scraper = Scraper.new @facebook_info["name"]
    rescue
    # Basically checks that we actually have a name for this artist.
      puts "J002: Failed, artist name could not be read."
      return false
    end

    if !@scraper.real_artist?
      # Skip artists that last.fm does not believe are real artists.
      puts "J002: Failed, last.fm did not believe '#{@facebook_info["name"]}' is a real artist"
      return false
    end

    return true
  end

  def scraper_initialise
    if @scraper.nil?
      @scraper = Scraper.new @facebook_info["name"]
    end
  end

  def import_info
    scraper_initialise
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
      @artist.image = io
      @artist.save!
      end
    else
      puts "Invalid image: #{@image_url.inspect}"
    end    
  end

  def import
    scraper_initialise
    
    if !error_checks
      return false
    end

    @artist = import_info
    save_image
    @artist.save!

    @user.suggest_artist @artist.id
    if !@artist.sdid.nil?
      ReleaseJob.perform_async(@artist.id)
    end
    end_time = Time.now
    elapsed_time = end_time - @start_time
    puts "New artist import finished after #{elapsed_time}"
    return @artist
  end

end