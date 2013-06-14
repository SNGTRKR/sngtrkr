require 'sidekiq'
class ArtistSubJob

  include Sidekiq::Worker
  sidekiq_options :queue => :artists, :backtrace => true

  def perform access_token, user_id, artist
    artist_scraper = ArtistScraper.new(:access_token => access_token, :user_id => user_id, :facebook_info => artist)
    a = artist_scraper.import
    User.find(user_id).followed_artists << a
    a
  end

end