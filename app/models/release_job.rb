class ReleaseJob

  @queue = :releasejob
  @sevendigital_apikey = "7dufgm34849u"
  if Rails.env.production?
    @proxy = 'http://localhost:3128'
  else
    @proxy = nil
  end

  def self.daily_release
    Artist.where(:ignore => false).each do |artist|
      Resque.enqueue(ReleaseJob, artist.id)
    end
  end

  def self.sdigital_import artist
    if !artist.sdid?
      return false
    end
    releases = Hash.from_xml( open("http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB&imageSize=350", :proxy => @proxy))["response"]["releases"]["release"]
    if releases.blank?
      return false
    end

    releases.each do |release|
      begin
        if release["id"].blank? or !artist.releases.where("sd_id = ?",release["id"]).empty? 
          next
        end
      rescue
        Rails.logger.error "J004: A release for artist '#{artist.name}' failed"
        next
      end
      r = Release.new
      
      # Check for duplicate and skip if present
      existing_duplicates = artist.releases.where(:name => release["title"])
      if !existing_duplicates.empty?
        existing_duplicate = existing_duplicates.first
        # If the new release came out earlier, change the release date of the existing release in the DB.
        if existing_duplicate.date > release["releaseDate"]
          existing_duplicate.date = release["releaseDate"]
          existing_duplicate.save
        end
        next
      end

      # Seven Digital
      r.artist_id = artist.id
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
      end
      
      Rails.logger.info("J003: Popularity of #{r.name} | #{release["popularity"]}")

      # Source the artwork from last.fm
      begin
        album_info = Scraper.lastfm_album_info(artist.name, r.name) 
        best_artwork = album_info['image'].last
      rescue
        best_artwork = nil
      end
      if best_artwork.is_a?(String)
        io = open(best_artwork, :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
      elsif release["image"]
        # Source the artwork from 7digital if last.fm don't have it.
        io = open(release["image"], :proxy => @proxy)
        if io
          def io.original_filename; base_uri.path.split('/').last; end
          io.original_filename.blank? ? nil : io      
          r.image = io
        end
      end
      r.save


      # Now get the track ID's for preview URLS
      begin
        tracks = Hash.from_xml(open("http://api.7digital.com/1.2/release/tracks?releaseid=#{r.sd_id}&oauth_consumer_key=#{@sevendigital_apikey}&country=GB", :proxy => @proxy))["response"]["tracks"]["track"]
      rescue
        Rails.logger.error("J003: Track scrape failed for release #{r.name} by #{artist.name}")
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
          t = Track.create(:release_id => r.id, :number => i, :name => title, :sd_id => track["id"])
          i = i+1
        rescue
          Rails.logger.error("J003: Individual track scrape failed for track: #{track.inspect}")
        end
      end
      
      # Get track previews from iTunes if you can't get them from 7digital
      if tracks.empty? and itunes_release
        Rails.logger.info("J007: Scraping tracks from iTunes for #{r.name}")
        i = 1
        itunes_release_tracks = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{itunes_release[0]['collectionId']}&entity=song&country=GB", :proxy => @proxy))['results']
        while !itunes_release_tracks[i].nil?
          t = Track.create(:release_id => r.id, :number => i, :name => itunes_release_tracks[i], :itunes_preview => itunes_release_tracks[i]['previewUrl'])
          i += 1
        end
      end
    end 
  end
    
  def self.itunes_import artist
    if artist.itunes_id?
      itunes_releases = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{artist.itunes_id}&entity=album&country=GB", :proxy => @proxy))['results']
      i = 1
      while !itunes_releases[i].nil?
        # Avoid importing the same album twice
        if !artist.releases.where("name LIKE ?", "%#{itunes_releases[i]['collectionName']}%").empty?
          i += 1
          next
        end
        r = Release.new
        Rails.logger.info("J004: new iTunes album found for #{artist.name} and #{itunes_releases[i]['collectionName']}")
        r.itunes = itunes_releases[i]['collectionViewUrl']
        r.artist_id = artist.id
        r.itunes_id = itunes_releases[i]["collectionId"]
        r.itunes = itunes_releases[i]['collectionViewUrl']
        r.name = itunes_releases[i]["collectionName"]
        r.date = itunes_releases[i]['releaseDate']
        r.scraped = 1
        
        album_info = Scraper.lastfm_album_info(artist.name, r.name)
        best_artwork = album_info['image'].last rescue best_artwork = nil
        if best_artwork
          begin
            io = open(best_artwork, :proxy => @proxy)
            if io
              def io.original_filename; base_uri.path.split('/').last; end
              io.original_filename.blank? ? nil : io      
              r.image = io
            end
          rescue
            Rails.logger.warn "ARTWORK EXCEPTION: " + best_artwork.inspect
          end
        else  
          # Itunes artwork is really shit quality so only use it if we must...
          if itunes_releases[i]["artworkUrl100"]
            io = open(itunes_releases[i]["artworkUrl100"], :proxy => @proxy)
            if io
              def io.original_filename; base_uri.path.split('/').last; end
              io.original_filename.blank? ? nil : io      
              r.image = io
            end
          end
        end
        r.save
        i += 1
      end     
    end
  end

  def self.perform(artist_id)
    if artist_id.blank? 
      raise "No Artist ID given"
    end
    require 'open-uri'
    start_time = Time.now
    artist = Artist.find(artist_id)

    # STAGE 1 - 7DIGITAL IMPORT
    sdigital_import artist
    
    # STAGE 2 - ITUNES IMPORT
    #itunes_import artist
      
    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J003: Release import for #{artist.name} finished after #{elapsed_time}"
  end
  
end