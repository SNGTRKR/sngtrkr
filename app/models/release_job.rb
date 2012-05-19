class ReleaseJob
  @queue = :releasejob
  @@sevendigital_apikey = "7dufgm34849u"
  def self.perform(artist_id)
    start_time = Time.now
    artist = Artist.find(artist_id)
    require 'open-uri'
    begin
      releases = Hash.from_xml( open( URI.parse("http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")))["response"]["releases"]["release"]
    rescue
      Rails.logger.error("J003: 7digital scrape failed ~ #{artist.sdid}")
    return false
    end
    releases.each do |release|
      r = Release.where("sd_id = ?",release["id"]).first rescue next
      if r.nil?
        r = Release.new
      elsif Rails.env.production? or !IMPORT_REPLACE
        Rails.logger.notice("J003: 7digital scrape stopped, release appear to already be in database for artist #{artist.name}")
      next
      end

      r.artist_id = artist.id
      r.sd_id = release["id"]
      r.name = release["title"]
      r.label_name = release["label"]["name"]
      r.date = release["releaseDate"]
      r.sdigital = release["url"]
      r.scraped = 1
      io = open(URI.escape(release["image"]))
      if io
        def io.original_filename; base_uri.path.split('/').last; end
        io.original_filename.blank? ? nil : io
      r.image = io
      end
      r.save
    end
    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J003: Release import for #{artist.name} finished after #{elapsed_time}"
  end
end