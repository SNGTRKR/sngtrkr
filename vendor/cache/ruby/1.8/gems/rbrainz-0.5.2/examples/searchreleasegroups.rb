#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Example script which searches the database for
# release groups and displays the release group data.
# 
# $Id: searchreleasegroups.rb 273 2009-05-24 22:29:04Z phw $

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Define the search parameters: Search for release groups from the
# band "Paradise Lost" and return a maximum of 10 release groups.
release_group_filter = Webservice::ReleaseGroupFilter.new(
  :artist => 'Paradise Lost',
  :limit => 10
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for release groups
# with the search parameters defined above.
release_groups = query.get_release_groups(release_group_filter)

# Display the fetched release group titles and the score, which
# indicates how good the release matches the search parameters.
release_groups.each do |entry|
  print "%s (%i%%)\r\n" % [entry.entity.title, entry.score]
end
