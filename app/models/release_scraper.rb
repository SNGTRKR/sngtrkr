class ReleaseScraper
  require 'open-uri'

  def initialize artist
    @artist = artist
    @sevendigital_apikey = "7dufgm34849u"
    @proxy = Scraper.proxy
    @releases = @artist.releases
    @new_releases = []
  end

  def releases
    return @new_releases + @releases
  end

  def import
    sd_count = sdigital_import || 0
    it_count = itunes_import || 0
    
    puts "Imported #{sd_count} 7digital releases and #{it_count} iTunes releases for #{@artist.name}"
    
    save_all
  end

  def duplicates? release

      all_releases = releases.collect { |r| {:name => r.name, :date => r.date, :id => r.id} }

      # Check for duplicate and skip if present
      existing_duplicate = all_releases.detect {|f| f[:name] == release["title"]}

      if existing_duplicate
        # If the new release came out earlier, change the release date of the existing release in the DB.
        if existing_duplicate[:date] > release["releaseDate"]
          r = Release.find(existing_duplicate[:id])
          r.date = release["releaseDate"]
          puts "Rewound release date of #{existing_duplicate[:name]} to #{existing_duplicate[:date]}"
          r.save
        end
        return true
      end
      return false
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
        if release["id"].blank? or !@artist.releases.where("sd_id = ?",release["id"]).empty? 
          next
        end
      rescue
        puts "J004: A release for artist '#{@artist.name}' failed"
        next
      end
      
      if duplicates? release
        next
      end

      r = @artist.releases.build

      # Seven Digital
      r.sd_id = release["id"]
      r.name = release["title"]
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
          puts "7digital import: Reduced release date to further back in time, from #{r.date} to #{itunes_date}"
          r.date = itunes_date
        end
      end
      
      puts("J003: Popularity of #{r.name} | #{release["popularity"]}")

      # Source the artwork from last.fm
      begin
        album_info = Scraper.lastfm_album_info(@artist.name, r.name) 
        best_artwork = album_info['image'].last
      rescue
        best_artwork = nil
      end
      if best_artwork.is_a?(String)
        puts "Valid image: #{best_artwork.inspect}"
        io = open(best_artwork, :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
      elsif release["image"]
        puts "7d image: #{release["image"].inspect}"
        # Source the artwork from 7digital if last.fm don't have it.
        io = open(release["image"], :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
      end
      @new_releases << r
      import_count += 1


      # Now get the track ID's for preview URLS
      begin
        tracks = Hash.from_xml(open("http://api.7digital.com/1.2/release/tracks?releaseid=#{r.sd_id}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB", :proxy => @proxy))["response"]["tracks"]["track"]
      rescue
        puts("J003: Track scrape failed for release #{r.name} by #{@artist.name}")
      end
      i = 1
      tracks.each do |track|
        begin
          if track["version"].blank?
            title = track["title"]
          else
          # Accounts for things like "Gold Dust (Netsky Remix)"
            track = "#{track["title"]} (#{track["version"]})"
          end
          r.tracks.build(:number => i, :name => title, :sd_id => track["id"])
          i += 1
        rescue
          puts("J003: Individual track scrape failed for track: #{track.inspect}")
        end
      end
      
      # Get track previews from iTunes if you can't get them from 7digital
      if tracks.empty? and itunes_release
        puts("J007: Scraping tracks from iTunes for #{r.name}")
        i = 1
        itunes_release_tracks = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{itunes_release[0]['collectionId']}&entity=song&country=GB", :proxy => @proxy))['results']
        while !itunes_release_tracks[i].nil?
          r.tracks.build(:number => i, :name => itunes_release_tracks[i], :itunes_preview => itunes_release_tracks[i]['previewUrl'])
          i += 1
        end
      end

      # Limit number of releases imported for testing purposes
      if opts[:limit] and import_count >= opts[:limit]
        return
      end

    end

    return import_count

  end
    
  def itunes_import opts={}
    import_count = 0
    if @artist.itunes_id?
      itunes_releases = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{@artist.itunes_id}&entity=album&country=GB", :proxy => @proxy))['results']
      i = 1
      while !itunes_releases[i].nil?
        # Avoid importing the same album twice
        existing = !@releases.where("name LIKE ?", "%#{itunes_releases[i]['collectionName']}%")
        if existing.empty?

          itunes_date = Time.zone.parse itunes_releases[i]['releaseDate']
          if itunes_date < existing.first.date
            puts "iTunes import: Reduced release date to further back in time"
            existing.first.date = itunes_date
            existing.first.save
          end
          i += 1
          next
        end
        r = @artist.releases.build
        puts("J004: new iTunes album found for #{@artist.name} and #{itunes_releases[i]['collectionName']}")
        r.itunes = itunes_releases[i]['collectionViewUrl']
        r.artist_id = @artist.id
        r.itunes_id = itunes_releases[i]["collectionId"]
        r.itunes = itunes_releases[i]['collectionViewUrl']
        r.name = itunes_releases[i]["collectionName"]
        r.date = itunes_releases[i]['releaseDate']
        r.scraped = 1
        
        album_info = Scraper.lastfm_album_info(@artist.name, r.name)
        # If Last.fm doesn't have artwork for it, it's probably not
        # actually a real release! So skip to the next release
        begin
          best_artwork = album_info['image'].last
        rescue
          i += 1
          next
        end

        if !best_artwork.is_a?(String)
          puts "Artwork Error: Release: '#{r.name}'. Expected String, actually got: '#{best_artwork.inspect}'"
          # Itunes artwork is really shit quality so only use it if we must...
          if itunes_releases[i]["artworkUrl100"]
            io = open(itunes_releases[i]["artworkUrl100"], :proxy => @proxy)
            if io
              def io.original_filename; base_uri.path.split('/').last; end
              io.original_filename.blank? ? nil : io      
              r.image = io
            end
          end
        else
          io = open(best_artwork, :proxy => @proxy)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end
        end
        @new_releases << r
        import_count += 1
        i += 1
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