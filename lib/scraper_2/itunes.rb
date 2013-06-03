module Scraper2
	class Itunes

		def self.associate_artist_with_store artist
			itunes_result = find_artist_in_store(artist.name)
			return false unless itunes_result
			artist.itunes = itunes_result[:itunes]
			artist.itunes_id = itunes_result[:itunes_id]
			artist
		end


		# TODO: Implement me.
		def self.scrape_artist itunes_id

		end

		private		
		def self.find_artist_in_store artist_name
			itunes_results = get_artists_from_store(artist_name)
			return false if itunes_results.empty?
			itunes_result = itunes_results.first

			return {
				itunes: itunes_result['artistLinkUrl'],
				itunes_id: itunes_result['artistId']
			}
		end

		def self.get_artists_from_store artist_name
			ITunesSearchAPI.search(
							term: artist_name, 
							country: "GB", 
							media: "music", 
							entity: "musicArtist"
						)
		end
	end
end