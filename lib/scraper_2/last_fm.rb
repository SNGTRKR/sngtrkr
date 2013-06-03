require 'open-uri'
require 'scraper_2/exceptions'

module Scraper2
  class LastFm

    @@api_endpoint = "http://ws.audioscrobbler.com/2.0/"
    @@api_key = "6541dc514e866d40539bfe4eddde211c"

    # Takes an existing Artist object and improves name and bio
    def self.improve_artist_info artist
      artist_info = get_artist_info(artist.name)
      if artist_info["lfm"]["artist"]["name"]
        artist.name = artist_info["lfm"]["artist"]["name"]
      end
      summary = @artist_info["lfm"]["artist"]["bio"]["summary"].to_s
      if summary =~ /is not an artist/
        raise ArtistScrapeError, "LastFm: #{artist.name} not a real artist"
      end
      artist.bio = summary
      artist
    end

    def self.release_info(artist_name, album_name)
      if artist_name.blank? or album_name.blank?
        raise "You have not specified an artist and album name"
      elsif !artist_name.is_a?(String) or !artist_name.is_a?(String)
        raise "Artist or album names are not strings: #{artist_name.inspect},  #{album_name.inspect}"
      end
      begin
        album_info = Hash.from_xml(open("http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=#{CGI.escape(artist_name)}&album=#{CGI.escape(album_name)}&api_key=#{@@api_key}&autocorrect=1", :proxy => @proxy))
      rescue
        Rails.logger.error("URL Issue for artist_name: '#{artist_name.inspect}' and album-name: '#{album_name.inspect}'")
        return false
      end
      begin
        album_info = album_info['lfm']['album']
      rescue
        return false # If there's an issue here, there were probably no results.
      end
      return album_info
    end

    def self.release_image(artist_name, album_name)
      album_info = lastfm_album_info(artist_name, album_name)
      if album_info and album_info['image'] and album_info['image'].last.is_a?(String)
        image = album_info['image'].last
      end
      return image
    end

    def self.artist_image(artist_name)
      artist_info = get_artist_info(artist_name)
      image = artist_info["lfm"]["artist"]["image"].try(:last)
      unless image.is_a? String
        return false
      end
      
      image
    end

    private
    def self.get_artist_info(artist_name)
      safe_name = CGI.escape(artist_name)
      Hash.from_xml(open("#{@@api_endpoint}?method=artist.getinfo&artist=#{safe_name}&api_key=#{@@api_key}&autocorrect=1"))
    end
  end
end
