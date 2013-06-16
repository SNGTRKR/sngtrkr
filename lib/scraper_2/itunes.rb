module Scraper2
	class Itunes

		### ARTIST 

		def self.associate_artist_with_store artist
			itunes_result = find_artist_in_store(artist.name)
			return false unless itunes_result
			artist.itunes = itunes_result[:itunes]
			artist.itunes_id = itunes_result[:itunes_id]
			artist
		end


		# TODO: Should scrape an artist entirely from iTunes, not based on FB or other.
		def self.scrape_artist itunes_id

		end

		### RELEASE

		# Scrapes *all* releases, no discrimination about duplicates. Its up to Scraper2 to deal
		# with the merging of these results into other records, if needed.
		def self.scrape_releases_for artist
			store_releases = get_releases_from_store(artist.itunes_id)
			releases = store_releases.map{ |r| process_store_release(artist.id, r) }

			return releases
		end

		private		

		#### ARTIST
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

		### RELEASE
		def self.get_releases_from_store itunes_id
			# Get all but the first result (which is the artist)
			ITunesSearchAPI.lookup(
							id: itunes_id,
							entity: "album",
							include_all_results: true
						)[1..-1]
		end

		def self.process_store_release artist_id, release
      return Release.new(
      	artist_id: artist_id,
	      itunes: release['collectionViewUrl'],
	      itunes_id: release["collectionId"],
	      itunes: release['collectionViewUrl'],
	      name: release["collectionName"],
	      date: release['releaseDate'],
	      scraped: true
      )
		end



	end
end