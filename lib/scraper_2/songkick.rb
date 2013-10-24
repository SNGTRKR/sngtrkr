module Scraper2
    class Songkick

        def associate_id(artist_name)
            artist_result = JSON.parse("http://api.songkick.com/api/3.0/search/artists.json?query=#{artist_name}&apikey=#{request.env['SONGKICK_API_KEY']}")
            artist.songkick_id = artist_result["id"]
            artist.save!
        end

    end
end