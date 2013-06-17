# encoding: utf-8
require 'open-uri'
require 'scraper_2/exceptions'

module Scraper2
  class LastFm

    @api_endpoint = "http://ws.audioscrobbler.com/2.0/"
    @api_key = "6541dc514e866d40539bfe4eddde211c"

    # Takes an existing Artist object and improves name and bio
    def self.improve_artist_info artist
      artist_info = get_artist_info(artist.name)
      summary = artist_info["bio"]["summary"].to_s

      if summary =~ /is not an artist/
        raise ValidationError, "LastFm: #{artist.name} not a real artist"
      end

      artist.name = artist_info["name"]
      artist.bio = summary
      artist
    end

    def self.release_image(artist_name, album_name)
      raise ArgumentError, "Argument is not a string" unless artist_name.is_a?(String) and album_name.is_a?(String)
      album_info = get_album_info(artist_name, album_name)
      process_image(album_info)
    end

    def self.artist_image(artist_name)
      raise ArgumentError, "Argument is not a string" unless artist_name.is_a? String
      artist_info = get_artist_info(artist_name)
      process_image(artist_info)
    end

    private
    def self.process_image(lfm_info)
      return nil if !lfm_info["image"]
      image = lfm_info["image"].last
      return nil if image == {"size" => "mega"} # Quirky Last.Fm API
      open_image(image) 
    end

    def self.get_artist_info(artist_name)
      safe_name = CGI.escape(artist_name)
      response = open("#{@api_endpoint}?method=artist.getinfo&artist=#{safe_name}&api_key=#{@api_key}&autocorrect=1")
      return Hash.from_xml(response)["lfm"]["artist"]
    rescue OpenURI::HTTPError => e
      raise ValidationError, "#{e} - #{artist_name}" 
    rescue Exception => e
      raise "LastFm error: Artist response not as expected for #{artist_name}. #{response} #{e} #{url}"
    end

    def self.get_album_info(artist_name, album_name)
      safe_artist_name = CGI.escape(artist_name)
      safe_album_name = CGI.escape(album_name)
      response = open("#{@api_endpoint}?method=album.getinfo&artist=#{safe_artist_name}&album=#{safe_album_name}&api_key=#{@api_key}&autocorrect=1")
      return Hash.from_xml(response)["lfm"]["album"]
    rescue OpenURI::HTTPError => e
      raise ValidationError, "#{e} - #{artist_name}, #{album_name}" 
    rescue Exception => e
      raise "LastFm error: Album response not as expected for #{artist_name}, #{album_name}. #{response} #{e}"
    end

    def self.open_image(url)
      io = open(URI.escape(url))
      if io
        def io.original_filename;
          base_uri.path.split('/').last;
        end

        io.original_filename.blank? ? nil : io
        return io
      else
        return nil
      end
    end

  end
end
