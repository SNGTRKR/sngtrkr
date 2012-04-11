#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Example script which queries the database for a
# release group and displays the release group's data.
# 
# $Id: getreleasegroup.rb 276 2009-05-24 23:37:18Z phw $

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# The release's MusicBrainz ID.
# Either read it from the command line as the first
# parameter or use a default one for demonstration.
id = $*[0] ? $*[0] : 'a07cbaff-aa79-35a9-9932-af7335f306eb'

# Generate a new release MBID object from the ID:
mbid = Model::MBID.parse(id, :release_group)

# Define what information about the release group
# should be included in the result.
# In this case the release group's artist and and
# releases will be fetched as well.
release_group_includes = Webservice::ReleaseGroupIncludes.new(
  :artist => true,
  :releases => true
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for the release
# group with the MBID defined above.
# We could as well use the ID string directly instead
# of the MBID object.
release_group = query.get_release_group_by_id(mbid, release_group_includes)

# Display the fetched release group data together with all
# unique release titles.
print <<EOF
ID            : #{release_group.id.uuid}
Title         : #{release_group.title}
Types         : #{release_group.types.to_a.join(", ")}
Artist        : #{release_group.artist.unique_name}
Releases      : #{release_group.releases.to_a.join("\r\n                ")}
EOF

