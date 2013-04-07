module Scraper2
	class ItunesRss

		# Gets the iTunes XML RSS feed, returning its body
		def self.fetch(rss_feed)
		end

		# Converts RSS body to Ruby objects
		def self.extract_releases(rss_body)
		end

		# Drops items where Artist is not in the database
		def self.remove_where_no_artist(rss_items)
		end

		# Lookup item in iTunes Search API and convert to a Release object
		def self.convert(rss_items)
		end

		# Fetches artwork from Last.fm where possible
		def self.fetch_artwork(releases)
		end

		def self.save_all(releases)
		end

	end
end