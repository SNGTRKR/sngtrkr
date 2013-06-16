require 'scraper_2/itunes'
require 'scraper_2/itunes_rss'
require 'scraper_2/last_fm'
require 'scraper_2/facebook'
require 'scraper_2/exceptions'
require 'open-uri'

module Scraper2

	### ARTIST 

	# Import an artist for a user
	def self.import_artist hash
		artist = scrape_artist hash
		return false unless artist and artist.save

		if hash[:user]
			follow_artist hash[:user], artist
		end

	end

	# Scrape all known sources (facebook / itunes / last.fm) for artist info
	#
	# Expects parameters:
	# (:fb_id, :fb_access_token) | :itunes_id | :fb_data
	def self.scrape_artist hash
		# Attempt to gather information from all the sources we got
		if hash[:fb_data]
			artist = Facebook.scrape_artist(fb_data: hash[:fb_data])
		elsif hash[:fb_id] and hash[:fb_access_token]
			artist = Facebook.scrape_artist(page_id: hash[:fb_id], access_token: hash[:fb_access_token])
		elsif hash[:itunes_id]
			artist = Itunes.scrape_artist hash[:itunes_id]
		end

		# Bail out if we don't have an artist to scrape from
		return false unless artist

		unless artist.itunes_id
			Itunes.associate_artist_with_store artist
		end

		LastFm.improve_artist_info artist

		scrape_artist_image artist

		return artist

	rescue ArtistScrapeError => e
		puts "Artist failed to scrape:"
		p e.message
		return false
	end

	# Scrape all known sources (last.fm) for artist image
	def self.scrape_artist_image artist
		prospective_image = LastFm.artist_image artist

		return false unless prospective_image
    puts "Valid image: #{@image_url.inspect}"
    io = open(URI.escape(@image_url))
    if io
      def io.original_filename;
        base_uri.path.split('/').last;
      end

      io.original_filename.blank? ? nil : io
      artist.image = io
    end
	end

	### RELEASE

	def self.scrape_releases_for artist
		itunes_releases = Itunes.scrape_releases_for artist

		# TODO: Get artwork

		save_all(itunes_releases)
	end

	### GENERAL

	# Batch save array of items to DB
	def self.save_all array
		array.each(&:save)
	end

	# Batch save! array of items to DB
	def self.save_all! array
		array.each(&:save!)
	end

	private

	### ARTIST

	def self.follow_artist user, artist
		user.followed_artists << artist
	end

	### RELEASE


end