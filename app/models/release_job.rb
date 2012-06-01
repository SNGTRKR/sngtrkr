class ReleaseJob < ActiveRecord::Base
  @queue = :releasejob
  @@sevendigital_apikey = "7dufgm34849u"
  def self.perform(artist_id)
  require 'open-uri'
    if(Rails.env.production?)
      	proxy = Net::HTTP::Proxy('127.0.0.1', 3128)      
    else
      	proxy = Net::HTTP
  	end
    start_time = Time.now
    artist = Artist.find(artist_id)
    #begin
      releases = Hash.from_xml( open("http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350"))["response"]["releases"]["release"]
    #rescue
    #  Rails.logger.error("J003: 7digital scrape failed ~ #{artist.sdid}")
    #return false
    #end
    releases.each do |release|
      r = Release.where("sd_id = ?",release["id"]).first rescue next
      if r.nil?
        r = Release.new
      elsif Rails.env.production? or !IMPORT_REPLACE
        Rails.logger.info("J003: 7digital scrape stopped, release appear to already be in database for artist #{artist.name}")
      next
      end

      r.artist_id = artist.id
      r.sd_id = release["id"]
      r.name = release["title"]
      r.label_name = release["label"]["name"]
      r.date = release["releaseDate"]
      r.cat_no = release["isrc"]
      r.sdigital = release["url"]
      r.scraped = 1
      Rails.logger.info("J003: Popularity of #{r.name} | #{release["popularity"]}")
      io = open(release["image"])
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io      
        r.image = io
      end
      r.save

      # Now get the track ID's for preview URLS
      begin
        tracks = Hash.from_xml(open("http://api.7digital.com/1.2/release/tracks?releaseid=#{r.sd_id}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB"))["response"]["tracks"]["track"]
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