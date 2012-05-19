class ArtistJob
  @queue = :artistjob
  def self.perform access_token, user_id
    start_time = Time.now
    require 'open-uri'
    graph = Koala::Facebook::API.new(access_token)
    music = graph.get_connections("me", "music?fields=name")
    i = 0
    artist_ids = music.each do |artist|
      artist["id"]
    end
    Koala::Facebook::BatchOperation.instance_variable_set(:@identifier, 0)
    results = []
    artist_ids.in_groups_of(50) do |artists|
      i=0
      results = graph.batch do |batch_api|
        for artist in artists do
          if(artist.nil?)
          Rails.logger.error "J001: Failed, batch api request returned nil."
          break
          end
          # TODO: DISABLE FOR PRODUCTION
          tmp = Artist.where("fbid = ?",artist["id"]).first
          if !tmp.nil? and (Rails.env.production? or !IMPORT_REPLACE)
            # Skip artists already in the database
            User.find(user_id).suggest_artist(tmp.id)            
          next
          end
          batch_api.get_object(artist["id"]+'?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio')
          i=i+1
        end
      end
      if Rails.env.development?
      # Limits the intake of artists to 50 when developing.
      break
      end
    end
    #Rails.logger.info(results)
    results.each do |artist|
      Resque.enqueue(ArtistSubJob, artist, user_id, access_token)
    end
    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "J001: Artist initial import delayed job after #{elapsed_time}"
    return true
  end
end
