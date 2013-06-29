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
    opts.reverse_merge!(first_time: false) 
    if opts[:artist].nil?
      raise "Scrape error: :fb_data not set. Hash: #{opts}"
    end
    # Returns false when scrape fails
    if artist = Scraper2.scrape_artist(fb_data: opts[:artist])      
      if artist.save
        follow_or_suggest_artist opts[:user_id], artist.id, opts[:first_time]
        ReleaseJob.perform_async(artist.id)
      end
    end
  end

  private

  def follow_or_suggest_artist user_id, artist_id, first_time
    if first_time
      Follow.create(user_id: user_id, artist_id: artist_id)
    else
      Suggest.create(user_id: user_id, artist_id: artist_id)
    end
  end

end