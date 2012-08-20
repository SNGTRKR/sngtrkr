class ReleaseScraper
  require 'open-uri'
  attr_accessor :releases, :new_releases_images

  def initialize artist, opts={}
    @artist = artist
    @sevendigital_apikey = "7dufgm34849u"
    @proxy = Scraper.proxy
    @releases = @artist.releases
    @new_releases = []
    if(opts[:preview_mode])
      @preview_mode = true
      @new_releases_images = []
    end
  end

  def import opts={}
    sd_count = sdigital_import(opts) || 0
    it_count = itunes_import(opts) || 0
    
    puts "Imported #{sd_count} 7digital releases and #{it_count} iTunes releases for #{@artist.name}"
    
    save_all
  end

  def duplicates? title, date = false

      all_releases = releases.collect { |r| {:name => r.name, :date => r.date, :id => r.id} }

      # Check for duplicate and skip if present
      existing_duplicate = all_releases.detect do |f| 
        # Ignore similar titles unless the longer one contains the word remix
        if f[:name].include? title and !f[:name].downcase["remix"]
          return true
        elsif title.include? f[:name] and !title.downcase["remix"]
          return true
        end
      end

      if date and existing_duplicate
        # If the new release came out earlier, change the release date of the existing release in the DB.
        if existing_duplicate[:date] > date
          r = Release.find(existing_duplicate[:id])
          r.date = date
          puts "Rewound release date of #{existing_duplicate[:name]} to #{existing_duplicate[:date]}"
          r.save
        end
        return true
      end
      return false
  end

  def self.improved_name name
    # Gets rid of (Featuring X) / (Feat X.) / (feat x) / [feat x]
    feat = / (\(|\[)(f|F)eat[^\)]*(\)|\])/
    ep = /( - |- )(EP|(S|s)ingle|(A|a)lbum)/
    ret = name.gsub( name.match(feat).to_s, "")
    ret = ret.gsub( ret.match(ep).to_s, "")
    return ret
  end

  def sdigital_import opts={}
    if !@artist.sdid?
      return false
    end
    releases = Hash.from_xml( open("http://api.7digital.com/1.2/artist/releases?artistId=#{@artist.sdid}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB&imageSize=350", :proxy => @proxy))["response"]["releases"]["release"]
    if releases.blank?
      return false
    end

    import_count = 0

    releases.each do |release|
      begin
        if release["id"].blank?
          next
        end
        existing_releases = @artist.releases.where("sd_id = ?",release["id"])
        if !existing_releases.empty?
          if opts[:improve_existing]
            r = existing_releases.first
          else
            next
          end
        else
          # Set so we can check if an existing release is being improved or not
          r = nil
        end
      rescue
        puts "RELEASE 7DIGITAL: A release for #{@artist.name} FAILED"
        next
      end
      
      # Only skip if we AREN'T improving an existing release
      if r.nil? and duplicates? release["title"], release["releaseDate"]
        next
      end

      puts("RELEASE 7DIGITAL: Scraping #{@artist.name} - #{release["title"]}")
      r ||= @artist.releases.build

      # Seven Digital
      r.sd_id = release["id"]
      r.name = ReleaseScraper.improved_name release["title"]
      r.label_name = release["label"]["name"]
      r.date = release["releaseDate"]
      r.cat_no = release["isrc"]
      r.sdigital = release["url"]
      r.upc = release["barcode"]
      r.scraped = 1
      
      # iTunes UPC lookup
      itunes_release = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?upc=#{release["barcode"]}&country=GB", :proxy => @proxy))['results'][0]
      if !itunes_release.nil?
        r.itunes = itunes_release['collectionViewUrl']
        itunes_date = Time.zone.parse itunes_release['releaseDate']
        if itunes_date < r.date
          puts "RELEASE 7DIGITAL: Reduced release date to further back in time, from #{r.date} to #{itunes_date}"
          r.date = itunes_date
        end
      end
      
      # Source the artwork from last.fm
      begin
        album_info = Scraper.lastfm_album_info(@artist.name, r.name) 
        best_artwork = album_info['image'].last
      rescue
        best_artwork = nil
      end
      if best_artwork.is_a?(String)
        puts "IMAGE 7DIGITAL: Last.fm image: #{best_artwork.inspect}"
        if @preview_mode
          @new_releases_images << best_artwork
        else
          io = open(best_artwork, :proxy => @proxy)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end
        end
      elsif release["image"]
        puts "IMAGE 7DIGITAL: 7Digital image: #{release["image"].inspect}"
        if @preview_mode
          @new_releases_images << release["image"]
        else
          # Source the artwork from 7digital if last.fm don't have it.
          io = open(release["image"], :proxy => @proxy)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end
        end
      elsif @preview_mode
        puts "IMAGE 7DIGITAL: Failed from all sources."
        @new_releases_images << "nope.jpg"
      end

      # Now get the track ID's for preview URLS
      begin
        tracks = Hash.from_xml(open("http://api.7digital.com/1.2/release/tracks?releaseid=#{r.sd_id}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB", :proxy => @proxy))["response"]["tracks"]["track"]
      rescue
        puts("TRACKS: Scrape failed for release #{r.name} by #{@artist.name}")
      end
      i = 1
      if !tracks.is_a? Array
        puts("TRACKS: Track scrape failed for tracks")
      else
        tracks.each do |track|
          if track["version"].blank?
            title = track["title"]
          else
          # Accounts for things like "Gold Dust (Netsky Remix)"
            track = "#{track["title"]} (#{track["version"]})"
          end
          r.tracks.build(:number => i, :name => title, :sd_id => track["id"])
          i += 1
        end
      end
      
      # Get track previews from iTunes if you can't get them from 7digital
      #if tracks.empty? and itunes_release
      #  puts("TRACKS: Scraping tracks from iTunes for #{r.name}")
      #  i = 1
      #  itunes_release_tracks = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{itunes_release[0]['collectionId']}&entity=song&country=GB", :proxy => @proxy))['results']
      #  while !itunes_release_tracks[i].nil?
      #    r.tracks.build(:number => i, :name => itunes_release_tracks[i], :itunes_preview => itunes_release_tracks[i]['previewUrl'])
      #    i += 1
      #  end
      #end
      #if r.tracks.count > 0
      #  puts "TRACKS: Total tracks count: #{r.tracks.count}"
      #end

      @new_releases << r
      import_count += 1

      # Limit number of releases imported for testing purposes
      if opts[:limit] and import_count >= opts[:limit]
        return
      end

    end

    return import_count

  end
    
  def itunes_import opts={}
    import_count = 0

    if !@artist.itunes_id?
      return import_count
    end

    itunes_releases = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{@artist.itunes_id}&entity=album&country=GB", :proxy => @proxy))['results']
    itunes_releases.each do |itunes_release|
      next if !itunes_release['collectionName']
      existing_releases = @artist.releases.where(:itunes_id, itunes_release["collectionId"])
      if !existing_releases.empty?
        if opts[:improve_existing]
          r = existing_releases.first
        else
          next
        end
      else
        r = nil
      end 
      
      next if duplicates? itunes_release['collectionName'], itunes_release['releaseDate']
        
      r ||= @artist.releases.build
      puts("RELEASE ITUNES: #{@artist.name} and #{itunes_release['collectionName']}")
      r.itunes = itunes_release['collectionViewUrl']
      r.artist_id = @artist.id
      r.itunes_id = itunes_release["collectionId"]
      r.itunes = itunes_release['collectionViewUrl']
      r.name = ReleaseScraper.improved_name itunes_release["collectionName"]
      r.date = itunes_release['releaseDate']
      r.scraped = 1
      
      album_info = Scraper.lastfm_album_info(@artist.name, r.name)
      if album_info and album_info['image'].is_a? Array
        best_artwork = album_info['image'].last
        puts "Artwork Error: Release: '#{r.name}'. Expected String, actually got: '#{best_artwork.inspect}'"
        # Itunes artwork is really shit quality so only use it if we must...
        if itunes_release["artworkUrl100"]
          if @preview_mode
          puts "IMAGE ITUNES: #{itunes_release["artworkUrl100"]}"
            @new_releases_images << itunes_release["artworkUrl100"]
          else
            io = open(itunes_release["artworkUrl100"], :proxy => @proxy)
            if io
              def io.original_filename; base_uri.path.split('/').last; end
              io.original_filename.blank? ? nil : io      
              r.image = io
            end
          end
        elsif @preview_mode
          puts "IMAGE ITUNES: Failed from all sources."
          @new_releases_images << "nope.jpg"
        end
      else
        if @preview_mode
          puts "IMAGE ITUNES: Last.fm #{best_artwork}"
          @new_releases_images << best_artwork
        else
          io = open(best_artwork, :proxy => @proxy)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end
        end
      end
      @new_releases << r
      import_count += 1

      # Limit number of releases imported for testing purposes
      if opts[:limit] and import_count >= opts[:limit]
        return
      end

    end

    return import_count
  end

  def save_all
    @new_releases.each do |r|
      r.save
    end
    @new_releases = []
    @releases = @artist.releases
  end

  def self.daily_release
    # Randomise order of artists so that if we do run out of API calls some day, artists all still get checked eventually.
    if Rails.env.production?
      rand = "RAND()"
    else
      rand = "RANDOM()"
    end
    Artist.where(:ignore => false).order(rand).each do |artist|
      ReleaseJob.perform_async(artist.id)
    end

    # Notify Matt that the Cron job ran
    m = ActionMailer::Base.mail(:from => "cron@sngtrkr.com", :to => "bessey@gmail.com", 
        :subject => '[SNGTRKR Cron] Successfully ran.') do |format|
      format.text { render :text => "The daily Release cronjob has run as expected" }
    end
    m.body = "The daily Release cronjob has run as expected"
    m.deliver
    puts "SNGTRKR Daily release has been run successfully."
  end


  end