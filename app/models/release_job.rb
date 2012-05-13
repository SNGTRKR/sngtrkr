class ReleaseJob
  @queue = :releasejob
  @@sevendigital_apikey = "7dufgm34849u"
  def self.perform artist
    require 'open-uri'
    begin
      releases =  Hash.from_xml( Net::HTTP.get( URI.parse(
      "http://api.7digital.com/1.2/artist/releases?artistId=#{artist.sdid}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")))["response"]["releases"]["release"]
    rescue
      Rails.logger.error("7digital scrape failed for release")
    return false
    end
    releases.each do |release|
      r = Release.where("sd_id = ?",release["id"]).first
      if r.nil?
        r = Release.new
      elsif rails_env.production?
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
  end
end
