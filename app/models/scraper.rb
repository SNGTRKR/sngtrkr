class Scraper
  include MusicBrainz
  @@sevendigital_apikey = "7dufgm34849u"
  require 'job/fb_job'
  require 'job/seven_digital'
  # DOCS FOR ALL THE SCRAPING MODULES
  # Last.fm (Scrobbler) - http://scrobbler.rubyforge.org/docs/
  # MusicBrainz - http://rbrainz.rubyforge.org/api-0.5.2/
  # 7digital -
  def self.musicBrainzSearch search
    search = MusicBrainz::Webservice::ArtistFilter.new :name => search
    # Gets the top musicbrainz result
    artist = MusicBrainz::Webservice::Query.new.get_artists(search).to_collection[0]
  end
  
  # Fetches an artist on 7digital and adds all their releases to the database. 
  def self.getReleases artist_id
    require 'resque'
    Resque.enqueue(SevenDigital, :releases, :artist_id => artist_id)
    return true
  end

  def self.lastFmSearch search
    artist = Scrobbler::Artist.new(search)
    puts 'Top Tracks'
    puts "=" * 10
    artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
  end

  def self.importFbLikes access_token
    # TODO: pass in user id as well for suggestions 
    Rails.logger = Logger.new(STDOUT)
    graph = Koala::Facebook::API.new(access_token)
    music = graph.get_connections("me", "music")
    i = 0
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
        b = Artist.new()
        b.name = "TOASTER"
        b.fbid = "41"
        b.save
        Rails.logger.info "ARTIST INPUT"
        if(Artist.find(:all, :conditions => ["fbid = '#{artist["id"]}'"]).count > 0)
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
        #Scraper.getReleases a.id
      end
    end
  end
  
end