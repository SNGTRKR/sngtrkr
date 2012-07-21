class ReleaseJob

  include Sidekiq::Worker
  sidekiq_options :queue => :release

  def perform(artist_id)
    if artist_id.blank? 
      raise "No Artist ID given"
    end
    require 'open-uri'
    start_time = Time.now
    artist = Artist.find(artist_id)

    # STAGE 1 - ITUNES IMPORT
    Release.itunes_import artist
    
    # STAGE 2 - 7DIGITAL IMPORT
    Release.sdigital_import artist

    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J003: Release import for #{artist.name} finished after #{elapsed_time}"
  end
  
end