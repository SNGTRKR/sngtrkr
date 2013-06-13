require 'sidekiq'
class ReleaseJob

  include Sidekiq::Worker
  sidekiq_options :queue => :releases, :backtrace => true

  def perform(artist_id)
    if artist_id.blank?
      raise "No Artist ID given"
    end
    require 'open-uri'
    start_time = Time.now
    artist = Artist.find(artist_id)

    release_scraper = ReleaseScraper.new artist
    release_scraper.import

    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J003: Release import for #{artist.name} finished after #{elapsed_time}"
  end


end