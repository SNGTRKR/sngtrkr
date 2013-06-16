require 'sidekiq'
class ReleaseJob

  include Sidekiq::Worker
  sidekiq_options :queue => :releases, :backtrace => true

  def perform(artist_id)
    artist = Artist.find(artist_id)
    Scraper2.import_releases_for(artist)
  end


end