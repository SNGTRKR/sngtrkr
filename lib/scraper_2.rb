require 'scraper_2/itunes'
require 'scraper_2/itunes_rss'
require 'scraper_2/last_fm'
require 'scraper_2/facebook'
require 'scraper_2/songkick'
require 'scraper_2/exceptions'
require 'open-uri'

module Scraper2

	### ARTIST 

	# Import an artist for a user
	def self.import_artist hash
		hash.reverse_merge!(first_time: false) 
		artist = scrape_artist hash
		return false unless artist and artist.save

		if hash[:user] 
			if hash[:first_time]
				follow_artist hash[:user], artist 
			else
				suggest_artist hash[:user], artist
			end
		end

		return true
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
		raise ArtistScrapeError, "No artist to work with from Itunes or Facebook" unless artist

		unless artist.itunes_id
			Itunes.associate_artist_with_store artist
		end

		# Assign songkick ID for artist
		# unless artist.songkick_id
		# 	Songkick.associate_id artist.name
		# end

		LastFm.improve_artist_info artist

		scrape_artist_image artist

		return artist

	# Exit if the artist is not valid.
	rescue ValidationError
		return false
	end

	# Scrape all known sources (last.fm) for artist image
	def self.scrape_artist_image artist
		artist.image = LastFm.artist_image(artist.name)
	end

	### RELEASE

	def self.import_releases_for artist
		releases = scrape_releases_for artist

		save_all(releases)
	end

	def self.scrape_all_missing_release_images
		Release.latest_missing_images.find_each do |r|
			r.save if scrape_missing_release_images(r)
		end		
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

	def self.suggest_artist user, artist
		user.suggested_artists << artist
	end

	### RELEASE

	def self.scrape_releases_for artist
		itunes_releases = []

		if artist.itunes_id
			itunes_releases = Itunes.scrape_releases_for artist
		end

		itunes_releases.each do |r|
			r.image = LastFm.release_image(artist.name, r.name)
		end

		releases = itunes_releases

		return releases
	end

	def self.scrape_missing_release_images r
		if r.image_last_attempt and (r.image_last_attempt + (2^r.image_attempts).hour) > Time.now
			return false
		end
		r.image_attempts = r.image_attempts ? r.image_attempts += 1 : 0
		r.image_last_attempt = Time.now
		artist_name = r.artist.try(:name)
		if artist_name.nil? then
			return false
		end
		r.image = LastFm.release_image(artist_name, r.name)

		return true
	end


end