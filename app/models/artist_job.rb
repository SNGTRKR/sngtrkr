class ArtistJob
  @queue = :artistjob
  def self.perform access_token, user_id
    start_time = Time.now
    require 'open-uri'
    graph = Koala::Facebook::API.new(access_token)
    music = graph.get_connections("me", "music?fields=name")
    i = 0
    artist_ids = music.each do |artist|
      artist["id"]
    end
    Koala::Facebook::BatchOperation.instance_variable_set(:@identifier, 0)
    artist_ids.in_groups_of(50) do |artists|
      i=0
      results = graph.batch do |batch_api|
        for artist in artists do
          if(artist.nil?)
          break
          end
          # TODO: DISABLE FOR PRODUCTION
          tmp = Artist.where("fbid = ?",artist["id"]).first
          if !tmp.nil? and (Rails.env.production? or !IMPORT_REPLACE)
            # Skip artists already in the database
            User.find(user_id).suggest_artist(tmp.id)
          next
          end
          batch_api.get_object(artist["id"]+'?fields=name,general_manager,booking_agent,record_label,genre,hometown,website,bio')
          i=i+1
        end
      end
      results.each do |artist|
        begin
          s = Scraper.new artist["name"]
        rescue
        # Basically checks that we actually have a name for this artist.
        next
        end
        if !s.real_artist?
        # Skip artists that last.fm does not believe are real artists.
        next
        end
        #a = Artist.new()
        a = Artist.where("fbid = ?",artist["id"]).first
        if a.nil?
          a = Artist.new()
        elsif Rails.env.production?
        next
        end
        split_regexp = /[,\/|+\.]/
        a.name = s.real_name
        a.fbid = artist["id"]
        a.bio = s.bio
        if s.bio.nil?
          a.bio = artist["bio"]
        end
        a.genre = artist["genre"].split(split_regexp).first rescue nil
        a.booking_email = artist["booking_agent"]
        a.manager_email = artist["general_manager"]
        a.hometown = artist["hometown"]
        a.label_name = artist["record_label"].split(split_regexp).first  rescue nil
        if(artist["website"])
          websites = artist["website"].split(' ')
        else
          websites = [];
        end
        itunes = ItunesSearch::Base.new
        begin
          a.itunes = itunes.search("term"=>a.name, "country" => "gb").results.first.artistViewUrl
        rescue
          a.itunes = nil
        end
        sd_info = Scraper.artist_sevendigital a.name
        if !sd_info.nil?
        a.sdid = sd_info[0]
        a.sd = sd_info[1]
        end
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
        User.find(user_id).suggest_artist a.id
        if !a.sdid.nil?
          Resque.enqueue(ReleaseJob, a.id)
        end
      end
      if Rails.env.development?
      # Limits the intake of artists to 50 when developing.
      break
      end
    end
    end_time = Time.now
    elapsed_time = end_time - start_time
    Rails.logger.info "Finished artist import delayed job after #{elapsed_time}"
    return true
  end
end
