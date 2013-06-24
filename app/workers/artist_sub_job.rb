require 'sidekiq'
class ArtistSubJob

  include Sidekiq::Worker
  sidekiq_options queue: :artists, :retry => false

  # Expects parameters:
  # :access_token, :user_id, :artist, 
  # 
  # Optionsal: 
  # :first_time
  def perform opts 
    # Optional hash parameters
    opts.symbolize_keys! # Necessary as Redis stringifies keys.
    if opts[:artist].nil?
      raise "Scrape error: :fb_data not set. Hash: #{opts}"
    end
    # Returns false when scrape fails
    if artist = Scraper2.import_artist(fb_data: opts[:artist], first_time: opts[:first_time])
      ReleaseJob.perform_async(artist.id)
    end
  end

end