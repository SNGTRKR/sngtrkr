class ReleaseJob
  @queue = :releasejob
  @@sevendigital_apikey = "7dufgm34849u"
  def self.perform(artist_id)
    require 'open-uri'
    if Rails.env.production?
      proxy = 'http://localhost:3128'
    else
      proxy = nil
    end
    start_time = Time.now
    artist = Artist.find(artist_id)

    releases = Hash.from_xml( open("http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350", :proxy => proxy))["response"]["releases"]["release"]

    releases.each do |release|
      r = Release.where("sd_id = ?",release["id"]).first rescue next
      if r.nil?
        r = Release.new
      elsif Rails.env.production? or !IMPORT_REPLACE
        Rails.logger.info("J003: 7digital scrape stopped, release appear to already be in database for artist #{artist.name}")
        next
      end
      
      # Check for duplicate and skip if present
      existing_duplicates = Release.where(:artist_id => artist.id, :name => release["title"])
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
      r.scraped = 1
      
      # iTunes UPC lookup
      itunes_release = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?upc=#{release["barcode"]}&country=GB"))['results'][0]
      if !itunes_release.nil?
        r.itunes = itunes_release['collectionViewUrl']
      end
      
      # iTunes Advanced
      
      #if artist.itunes_id?
      #  itunes_releases = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{artist.itunes_id}&entity=album&country=GB"))['results']
      #  i = 1
      #  while !itunes_releases[i].nil?
      #    # If either is a substring of the other
      #    if r.name.include? itunes_releases[i]['collectionName'] or itunes_releases[i]['collectionName'].include? r.name
      #      Rails.logger.info("J004: iTunes substring found for #{r.name} and #{itunes_releases[i]['collectionName']}")
      #      r.itunes = itunes_releases[i]['collectionViewUrl']
      #      itunes_release_date = Date.strptime itunes_releases[i]['releaseDate']
      #      # Take the earliest of the two release dates.
      #      if itunes_release_date < r.date.to_datetime
      #        r.date = itunes_release_date
      #      end
      #      break
      #    end
      #    i += 1
      #  end
      #  itunes_releases = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{artist.itunes_id}&entity=song&country=GB"))['results']
        
      # end
      
      Rails.logger.info("J003: Popularity of #{r.name} | #{release["popularity"]}")
      io = open(release["image"], :proxy => proxy)
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io      
        r.image = io
      end
      r.save

      # Now get the track ID's for preview URLS
      begin
        tracks = Hash.from_xml(open("http://api.7digital.com/1.2/release/tracks?releaseid=#{r.sd_id}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB", :proxy => proxy))["response"]["tracks"]["track"]
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
      
    end
    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J003: Release import for #{artist.name} finished after #{elapsed_time}"
  end
end