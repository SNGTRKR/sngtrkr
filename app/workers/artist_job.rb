require 'sidekiq'
class ArtistJob
  include Sidekiq::Worker
  sidekiq_options :queue => :artists, :retry => false

  def perform access_token, user_id, first_time = false
    artists = Scraper2::Facebook.get_all_artists_for_user(access_token)

    new_artists, old_artists = filter_existing_artists(artists)

    suggest_existing_artists(user_id, old_artists)

    import_new_artists(
      access_token: access_token, 
      user_id: user_id, 
      artists: new_artists,
      first_time: first_time)
  end

  private

  # Split artists into existing in DB count, and new
  def filter_existing_artists artists
    new_artists, old_artists = [], []
    artists.each do |artist|
      db_artist = Artist.find_by_fbid(artist["id"])
      if db_artist.nil?
        new_artists << artist
      else
        old_artists << db_artist
      end
    end

    return new_artists, old_artists
  end

  def suggest_existing_artists user_id, artists
    artists.each do |artist|
      Suggest.create(:user_id => user_id, :artist_id => artist.id)
    end
  end

  def import_new_artists opts
    opts[:artists].each do |artist|
      hash = {
        access_token: opts[:access_token], 
        user_id: opts[:user_id], 
        artist: artist,
        first_time: opts[:first_time]
      }
      ArtistSubJob.perform_async(hash)
    end
  end

end
