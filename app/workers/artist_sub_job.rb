class ArtistSubJob
  @@sevendigital_apikey = "7dufgm34849u"
  include Sidekiq::Worker  
  sidekiq_options :queue => :artist

  def perform access_token, user_id, artist
    Artist.import(access_token, user_id, artist)
  end

end