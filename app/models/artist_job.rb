class ArtistJob
  @queue = :artistjob
  def self.perform access_token, user_id
    require 'open-uri'
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
          # TODO: DISABLE FOR PRODUCTION
          tmp = Artist.where("fbid = ?",artist["id"]).first
          if !tmp.nil? and Rails.env.production?
            # Skip artists already in the database
            User.find(user_id).suggest(tmp.id)
          next
          end
          batch_api.get_object(artist["id"])
          i=i+1
        end
      end
      results.each do |artist|
        s = Scraper.new artist["name"]
        if !s.real_artist?
        # Skip artists that last.fm does not believe are real artists.
        next
        end
        #a = Artist.new()
        a = Artist.where("fbid = ?",artist["id"]).first;
        if a.nil?
          a = Artist.new()
        elsif Rails.env.production?
        next
        end
        a.name = s.real_name
        a.fbid = artist["id"]
        details = graph.get_object(artist["id"])
        a.bio = s.bio
        if s.bio.nil?
          a.bio = details["bio"]
        end
        a.genre = details["genre"]
        a.booking_email = details["booking_agent"]
        a.manager_email = details["general_manager"]
        a.hometown = details["hometown"]
        a.label_name = details["record_label"]
        if(details["website"])
          websites = details["website"].split(' ')
        else
          websites = Array("");
        end
        itunes = ItunesSearch::Base.new
        begin
          a.itunes = itunes.search("term"=>a.name, "country" => "gb").results.first.artistViewUrl
        rescue
        end
        sd_info = Scraper.artist_sevendigital a.name
        a.sdid = sd_info[0]
        a.sd = sd_info[1]
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
        image = s.lastFmArtistImage
        if image != false
          io = open(URI.escape(image))
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io
          a.image = io
          end
        end
        a.save
        User.find(user_id).suggest a.id
        if !a.sdid.nil?
          Resque.enqueue(ReleaseJob, a)
        end
      end
      if Rails.env.development?
      # Limits the intake of artists to 50 when developing.
      break
      end
    end
  end
end
