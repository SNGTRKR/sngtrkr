class Scraper
  include MusicBrainz
  @@sevendigital_apikey = "7dufgm34849u"
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
    search = Artist.find(artist_id).name
    xml =  Hash.from_xml Net::HTTP.get( URI.parse("http://api.7digital.com/1.2/artist/search?q=#{URI.escape(search)}&sort=score%20desc&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB"))
    results = xml["response"]["searchResults"]["searchResult"]
    # Necessary to still return an ID when we have multiple artist possibilities (picks first artist)
    if results.kind_of?(Array)
    results = results[0]
    end
    id = results["artist"]["id"]
    releases =  Hash.from_xml( Net::HTTP.get( URI.parse(
    "http://api.7digital.com/1.2/artist/releases?artistId=#{id}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")))["response"]["releases"]["release"]
    releases.each do |release|
      if(Release.find(:all, :conditions => ["sd_id = ?",release["id"]]).count > 0)
      next
      end

      require 'open-uri'
      require 'net/http'
      file = open release["image"]

      r = Release.new
      r.artist_id = artist_id
      r.sd_id = release["id"]
      r.name = release["title"]
      r.label_name = release["label"]["name"]
      r.date = release["releaseDate"]
      r.sdigital = release["url"]
      r.scraped = 1
      r.image = file

      r.save
    # r.rls_type = release["type"] # Single, Album

    end

  end

  def self.lastFmSearch search
    artist = Scrobbler::Artist.new(search)
    puts 'Top Tracks'
    puts "=" * 10
    artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
  end

  def self.importFbLikes access_token, user_id
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
          tmp = Artist.find(:all, :conditions => ["fbid = ?",artist["id"]]).first
          if(tmp != nil)
            # Skip artists already in the database
            User.find(user_id).suggest(tmp.id)
          next
          end
          batch_api.get_object(artist["id"])
          i=i+1
        end
      end
      results.each do |artist|
      # TODO: Import artist image as well.
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
        require 'open-uri'
        require 'net/http'
        file = open details["picture"]
        a.image = file
        a.save
        User.find(user_id).suggest a.id
        if a.id != nil
          Scraper.delay.getReleases a.id
        end
      end
      if Rails.env.development?
      # Limits the intake of artists to 50 when developing.
      break
      end
    end

  end

end