require 'open-uri'

module Scraper2
	class ItunesRss

		@import_limit = 100
		@scrape_regularity = 3.hours

		def self.import_all_feeds
			import_rss_feed(open(new_releases_url))
			import_rss_feed(open(just_added_url))
		end

		def self.import_rss_feed(feed)
			rss_items = fetch_releases(feed)
			relevant_rss_items = remove_where_no_artist(rss_items)
			releases = convert(relevant_rss_items)
			fetch_artwork(releases)
			save_all(releases)
		end

		def self.new_releases_url
			return "http://itunes.apple.com/WebObjects/MZStore.woa/wpa/MRSS/newreleases/sf=143444/limit=" +
				@import_limit.to_s + "/explicit=true/rss.xml"
		end

		def self.just_added_url
			return "http://itunes.apple.com/WebObjects/MZStore.woa/wpa/MRSS/justadded/sf=143444/limit=" +
				@import_limit.to_s + "/explicit=true/rss.xml"
		end


		# Gets the iTunes XML RSS feed, returning its body, an array of items with keys:
		# ["title", "link", "description", "pubDate", "encoded", "category", "artist", "artistLink",
		#  "album", "albumLink", "albumPrice", "coverArt", "rights", "releasedate"]
		def self.fetch_releases(rss_feed)
			rss = Hash.from_xml(rss_feed)
			rss_items = rss["rss"]["channel"]["item"]
			return rss_items
		end

		# Drops items where Artist is not in the database
		# And add artistItunesId and artistId to hash while we're at it
		def self.remove_where_no_artist(rss_items)
			items = []
			rss_items.each do |item|
				itunes_artist_id = id_from_url(item["artistLink"])
				artist = Artist.find_by_itunes_id(itunes_artist_id)
				if artist
					item["artistItunesId"] = itunes_artist_id
					item["artistId"] = artist.id
					items << item
				end
			end
			return items
		end

		# Lookup item in iTunes Search API and convert to a Release object
		def self.convert(rss_items)
			releases = []
			rss_items.each do |item|
				itunes_id = id_from_url(item["albumLink"])
				itunes_json_release = ITunesSearchAPI.lookup(:id => itunes_id)
				# ITunesSearchAPI.lookup returns these results:
				# wrapperType, collectionType, artistId, collectionId, amgArtistId, artistName, 
				# collectionName, collectionCensoredName, artistViewUrl, collectionViewUrl, artworkUrl60, 
				# artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, 
				# currency, releaseDate, primaryGenreName
				if itunes_json_release.nil? then next end

				r = Release.new({
					:artist_id => item["artistId"],
					:itunes_id => id_from_url(item["albumLink"]),
					:itunes => item["albumLink"],
					:name => itunes_json_release["collectionName"],
					:scraped => true,
					:date => item["releasedate"].to_date
				})
				releases << r
			end

			return releases
		end

		# Fetches artwork from Last.fm where possible
		def self.fetch_artwork(releases)
			releases.each do |r|
				r.image = LastFm.release_image(r.artist.name,r.name)
			end

			return releases
		end

		def self.save_all(releases)
			releases.each do |r|
				r.save
			end
		end

		# UTILITY FUNCTIONS #

		def self.id_from_url(url)
			match = /(?:itunes\.apple\.com\/(artist|album)\/.*\/id)([0-9]+)/.match(url)
			if match.nil?
				return false
			else
				return match[2].to_i
			end
		end

	end
end