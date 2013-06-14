require 'sidekiq'
class ArtistSubJob

  include Sidekiq::Worker
  sidekiq_options queue: :artists, backtrace: true

  # Expects parameters:
  # :access_token, :user_id, :artist, 
  # 
  # Optionsal: 
  # :first_time
  def perform opts 
    # Optional hash parameters
    opts.reverse_merge!(first_time: false)
    artist = Scraper2::Facebook.scrape_artist(fb_data: opts[:artist])
    # binding.pry
    artist.save
    follow_or_suggest_artist opts[:user_id], artist.id, opts[:first_time]
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