class Track < ActiveRecord::Base
  validates :name, :presence => true
  belongs_to :release

  def preview
    require 'open-uri'
    Rails.logger.debug("Fetched track from 7digital. #{Time.now}")
    Hash.from_xml( open( URI.parse("http://api.7digital.com/1.2/track/preview?trackid=#{sd_id}&oauth_consumer_key=7dufgm34849u&redirect=false")))["response"]["url"] rescue return false
  end
  
  def self.ordered
    order('number')
  end
end
