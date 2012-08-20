class ArtistScraper
  attr_accessor :image_url, :artist

  require 'open-uri'

  def initialize opts={}
    if !opts[:facebook_info] and !opts[:artist_id]
      raise "ArtistScraper ERROR: No artist information given"
    end
    if opts[:artist_id]
      @artist = Artist.find(opts[:artist_id])
    end
    @facebook_info = opts[:facebook_info]
    if opts[:user_id]
      @user = User.find(opts[:user_id])
    end
    if opts[:access_token]
      @access_token = opts[:access_token]
    end
  end

  def import
    scraper_initialise
    
    if errors?
      return false
    end

    @artist = import_info
    save_image
    @artist.save!

    @user.suggest_artist @artist.id
    if !@artist.sdid.nil? or !@artist.itunes_id.nil?
      ReleaseJob.perform_async(@artist.id)
    end
    return @artist
  end

  def self.fb_single_import access_token, page_id, user_id
    graph = Koala::Facebook::API.new(access_token)
    artist = graph.api("/#{page_id}?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
    db_artist = import_info(access_token, user_id, artist)
    db_artist.save
    User.find(user_id).following << db_artist
    return db_artist
  end

  def self.improve_all
    Artist.all.each do |artist|
      scraper = ArtistScraper.new :artist_id => artist.id
      new_artist = scraper.import_stores :improve_existing => true
      new_artist.save!
      ReleaseJob.perform_async(new_artist.id)
    end
  end

  def self.improve_all_artwork
    Artist.all.each do |artist|
      if artist.image.to_s == "/images/original/missing.png"
        next
      end
      image = 'public'+artist.image.to_s.split('?')[0]
      begin
        open(Rails.root.join(image))
        puts "Artist fine '#{artist.name}'"
      rescue
        puts "No image for artist '#{artist.name}'"
        s = Scraper.new artist.name
        lfm_image = s.lastFmArtistImage
        if lfm_image
          io = open(URI.escape(lfm_image))
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io
            artist.image = io
          end
        end
        artist.save!
      end
    end
  end
  

  def errors? opts={}
    # Check artist isn't already in database
    if Artist.where(:fbid => @facebook_info["id"]).count > 0 and !opts[:preview_mode]
      puts "ARTIST ERROR: Tried to log an artist that is already in the database: '#{@facebook_info["name"]}'"
      return true
    end

    # If they are a record label, do not import them into the database
    if @facebook_info["name"].downcase["records"] and @facebook_info["name"].length > 15
      puts "ARTIST ERROR: "
      return true
    end

    begin
      if @facebook_info["likes"] < 100
        puts "ARTIST ERROR: They have only #{@facebook_info["likes"]} likes"
        return true
      end
    rescue
      puts "ARTIST ERROR: Artist's like count could not be read."
    end

    begin
      @scraper = Scraper.new @facebook_info["name"]
    rescue
    # Basically checks that we actually have a name for this artist.
      puts "ARTIST ERROR: Artist name could not be read."
      return true
    end

    if !@scraper.real_artist?
      # Skip artists that last.fm does not believe are real artists.
      puts "ARTIST ERROR: Last.fm did not believe '#{@facebook_info["name"]}' is a real artist"
      return true
    end

    return false
  end

  def scraper_initialise
    if !@scraper.nil?
      return true
    end
    if !@facebook_info["name"]
      raise "Scraper initialize error: no artist name given"
    end
    @scraper = Scraper.new @facebook_info["name"]
  end

  def import_info opts={}

    @start_time = Time.now
    puts "Starting import of #{@facebook_info["name"]}".upcase

    puts "Initializing Last.fm scraper"
    scraper_initialise
    # Once we've covered the basic failing criteria, initialize variables (as late as possible)
    require 'open-uri'
    
    puts "Importing facebook and last.fm data"
    split_regexp = /[,\/|+\.]/
    @artist = Artist.new
    @artist.name = @scraper.real_name
    @artist.fbid = @facebook_info["id"]
    @artist.bio = @scraper.bio
    
    if @scraper.bio.nil?
      @artist.bio = @facebook_info["bio"]
    end
    
    @artist.genre = @facebook_info["genre"].split(split_regexp).first rescue nil
    @artist.booking_email = @facebook_info["booking_agent"]
    @artist.manager_email = @facebook_info["general_manager"]
    @artist.hometown = @facebook_info["hometown"]
    @artist.label_name = @facebook_info["record_label"].split(split_regexp).first  rescue nil
    
    if(@facebook_info["website"])
      websites = @facebook_info["website"].split(' ')

      websites.each do |website|
        if(website.length < 5)
          next
        end
        if(website =~ /(?<=twitter\.com\/)(#!\/)?(.*)/)
          @artist.twitter = $&
        elsif(website =~ /(?<=youtube\.com\/)(#!\/)?(.*)/)
          @artist.youtube = $&
        elsif(website =~ /(?<=soundcloud\.com\/)(#!\/)?(.*)/)
          @artist.soundcloud = $&
        else
          @artist.website = website
        end
      end

    else
    websites = []
    end

    puts "Importing Last.fm image"
    @image_url = @scraper.lastFmArtistImage

    end_time = Time.now
    elapsed_time = end_time - @start_time
    puts "New artist import finished after #{elapsed_time}"

    import_stores opts
    return @artist
  end

  def import_stores opts={}
    puts "Importing iTunes data"
    begin
      itunes_results = ITunesSearchAPI.search(:term => @artist.name, :country => "GB", :media => "music", :entity => "musicArtist").first
      # Delete existing releases by this artist if their artist_id on itunes has changed
      if opts[:improve_existing] and @artist.itunes_id != itunes_results['artistId']
        @artist.releases.where("itunes != ?", nil).delete_all
      end
      @artist.itunes = itunes_results['artistLinkUrl']
      @artist.itunes_id = itunes_results['artistId']
      puts "Found artist with ID #{@artist.itunes_id}"
    rescue
     puts "Couldn't find artist on iTunes"
     @artist.itunes = nil
    end

    puts "Importing 7digital data"
    sd_info = Scraper.artist_sevendigital @artist.name
    
    if sd_info
      # Delete existing releases by this artist if their id on 7digital has changed
      if opts[:improve_existing] and @artist.sdid != sd_info[0]
        @artist.releases.where("sd_id != ?", nil).delete_all
      end

      @artist.sdid = sd_info[0]
      @artist.sd = sd_info[1]
    end
    return @artist
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

end