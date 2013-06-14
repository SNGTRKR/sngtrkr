require 'sidekiq'
class ArtistJob
  include Sidekiq::Worker
  sidekiq_options :queue => :artists, :backtrace => true

  def perform access_token, user_id, first_time = false
    artists = get_artists_from_facebook(access_token)

    new_artists, old_artists = filter_existing_artists(artists)

    suggest_existing_artists(user_id, old_artists)

    import_new_artists(
      access_token: access_token, 
      user_id: user_id, 
      artists: new_artists,
      first_time: first_time)
  end

  private

  def get_artists_from_facebook access_token
    graph = Koala::Facebook::API.new(access_token)
    return graph.get_connections(
      "me", 
      "music?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes"
      )
  end

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
      ArtistSubJob.perform_async(
        access_token: opts[:access_token], 
        user_id: opts[:user_id], 
        artist: artist,
        first_time: false)
    end
  end

end
