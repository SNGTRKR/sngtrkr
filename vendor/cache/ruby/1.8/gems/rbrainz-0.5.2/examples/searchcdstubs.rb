#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Example script which searches the database for
# releases by disc ID, including CD stubs.
#
# For more information about CD stubs see http://wiki.musicbrainz.org/CDStub
#
# $Id: searchcdstubs.rb 273 2009-05-24 22:29:04Z phw $

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Define the search parameters: Search for releases with the given disc ID
# (which is a special disc ID for DVD releases and only available as a CD stub),
# make sure to include CD stubs and return a maximum of 10 releases.
release_filter = Webservice::ReleaseFilter.new(
  :discid => 'flplyXqMOiodZEDJeDw5Ci6OD_g-',
  :cdstubs => true,
  :limit => 10
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for releases
# with the search parameters defined above.
releases = query.get_releases(release_filter)

# Display the fetched release titles and their tracks
releases.each do |entry|
  release = entry.entity
  puts "Title : #{release.title}"
  puts "Tracks: #{release.tracks.to_a.join("\r\n        ")}"
end
