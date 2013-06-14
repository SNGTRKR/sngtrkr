require 'open-uri'

module Scraper2
  class Facebook

    @graph_api = Koala::Facebook::API

    # Returns a valid artist on successfull import, or false otherwise
    # Can either take a facebook page ID, or the page's data, for processing
    # Expects:
    # (:page_id, :access_token) | :fb_data
    def self.scrape_artist opts
      if opts[:fb_data]
        graph_artist = opts[:fb_data]
      else  
        graph_artist = get_page_from_graph opts[:page_id], opts[:access_token]
      end
      return false if graph_artist["error"]

      artist = Artist.new(
        name: graph_artist["name"],
        fbid: graph_artist["id"],
        bio: graph_artist["bio"],
        genre: find_first(graph_artist["genre"]),
        booking_email: graph_artist["booking_agent"],
        manager_email: graph_artist["general_manager"],
        hometown: graph_artist["hometown"],
        label_name: find_first(graph_artist["record_label"])
        )

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

    def self.find_first list
      split_regexp = /[,\/|+\.]/
      list.split(split_regexp).first rescue nil
    end

  end
end