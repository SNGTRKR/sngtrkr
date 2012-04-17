class FbJob
  require "rails"
  @queue = :facebook_batches;

  def self.perform access_token
    graph = Koala::Facebook::API.new(access_token)
    music = graph.get_connections("me", "music")
    artist_ids = music.each do |artist|
      artist["id"]
    end
    Koala::Facebook::BatchOperation.instance_variable_set(:@identifier, 0)
    artist_ids.in_groups_of(50) do |artists|
      i=0
      results = graph.batch do |batch_api|
        for artist in artists do
          if(artist == nil)
          break
          end
          batch_api.get_object(artist["id"])
          i=i+1
        end
      end
      results.each do |artist|
        if(Artist.find(:all, :conditions => ["fbid = '#{artist["id"]}'"]))
          # Skip artists already in the database
          next
        end
        a = Artist.new()
        a.name = artist["name"]
        a.fbid = artist["id"]
        details = graph.get_object(artist["id"])
        a.bio = details["bio"]
        a.genre = details["genre"]
        a.booking_email = details["booking_agent"]
        a.manager_email = details["general_manager"]
        a.hometown = details["hometown"]
        a.label = details["label"]
        if(details["website"])
          websites = details["website"].split(' ')
        else
          websites = Array("");
        end
        a.twitter = ""
        a.youtube = ""
        a.soundcloud =""
        a.website = ""
        websites.each do |website|
          if(website.length < 5)
          next
          end
          if(website =~ /(?<=twitter\.com\/)(#!\/)?(.*)/)
          a.twitter = $&
          elsif(website =~ /(?<=youtube\.com\/)(#!\/)?(.*)/)
          a.youtube = $&
          elsif(website =~ /(?<=soundcloud\.com\/)(#!\/)?(.*)/)
          a.soundcloud = $&
          else
          a.website = website
          end
        end
        a.save
        Scraper.getReleases a.id
      end
    end
  end
end
