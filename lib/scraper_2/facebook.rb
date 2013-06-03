require 'open-uri'

module Scraper2
  class Facebook

    @graph_api = Koala::Facebook::API

    # Returns a valid artist on successfull import, or false otherwise
    def self.scrape_artist page_id, access_token
      graph_artist = get_page_from_graph page_id, access_token
      return false if graph_artist["error"]

      split_regexp = /[,\/|+\.]/
      artist = Artist.new
      artist.name = graph_artist["name"]
      artist.fbid = graph_artist["id"]
      artist.bio = graph_artist["bio"]

      artist.genre = graph_artist["genre"].split(split_regexp).first rescue nil
      artist.booking_email = graph_artist["booking_agent"]
      artist.manager_email = graph_artist["general_manager"]
      artist.hometown = graph_artist["hometown"]
      artist.label_name = graph_artist["record_label"].split(split_regexp).first rescue nil

      if graph_artist["website"]
        websites = graph_artist["website"].split(' ')

        websites.each do |website|
          if (website.length < 5)
            next
          end
          if website =~ /(?<=twitter\.com\/)(#!\/)?(.*)/
            artist.twitter = $&
          elsif website =~ /(?<=youtube\.com\/)(#!\/)?(.*)/
            artist.youtube = $&
          elsif website =~ /(?<=soundcloud\.com\/)(#!\/)?(.*)/
            artist.soundcloud = $&
          else
            artist.website = website
          end
        end
      end

      return artist

    end

    private

    def self.get_page_from_graph page_id, access_token
      graph = @graph_api.new(access_token)
      return graph.api("/#{page_id}?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio,picture,likes")
    end

  end
end