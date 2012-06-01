class ArtistJob
  @queue = :artistjob
  def self.perform access_token, user_id
    start_time = Time.now
    graph = Koala::Facebook::API.new(access_token)
    music = graph.get_connections("me", "music?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
    user = User.find(user_id)
    new_artists, old_artists = [], 0
    # Reduce import for development
    if Rails.env.development?
      music = music[0..20]
    end
    music.each do |artist|
      a = Artist.where("fbid = ?",artist["id"]).first
      if a.nil?
      new_artists << artist
      else
      # Suggest artists already in the database and skip over them
      user.suggest_artist(a.id)
      old_artists += 1
      end
    end
    artist_end_time = Time.now
    artist_elapsed_time = artist_end_time - start_time
    Rails.logger.info "J001: Existing artists import finished after #{artist_elapsed_time}, #{old_artists} artists imported"

    new_artists.each do |artist|
      Resque.enqueue(ArtistSubJob, access_token, user_id, artist)
    end
  end
end
