#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Example for submitting ISRCs to MusicBrainz.
# This script will submit the ISRCs for the release Clayman by In Flames
# (http://musicbrainz.org/album/1de625a1-55a5-4f8a-96f9-6d0a2a37ddcd.html).
# The ISRCs were taken from the GEMA database at
# http://mgonline.gema.de/soundcarrier/searchTracks.do?id=370495&seq=1&title=CLAYMAN
#
# $Id: submit_isrcs.rb 273 2009-05-24 22:29:04Z phw $

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Get the username and password
print 'Username: ' unless ARGV[0]
username = ARGV[0] ? ARGV[0] : STDIN.gets.strip
print 'Password: ' unless ARGV[1]
password = ARGV[1] ? ARGV[1] : STDIN.gets.strip

# Set the authentication for the webservice.
ws = Webservice::Webservice.new(
       :host     => 'musicbrainz.org',
       :username => username,
       :password => password
) 

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new(ws, :client_id => 'RBrainz test ' + RBRAINZ_VERSION)

# Submit the ISRCs for some tracks.
query.submit_isrcs([
  ['7f574ec1-344c-4ae1-970d-3c757f9a717e', 'DED830049301'],
  ['1393122c-364c-4fb6-9a4b-17eddce90152', 'DED830049302'],
  ['2634965c-5299-4958-b0dc-47b166bb6898', 'DED830049303'],
  ['dad6b8a4-0412-4a80-9123-3e0ebddaf82d', 'DED830049304'],
  ['e1f7e805-33f3-4663-b294-3805b82405f9', 'DED830049305'],
  ['d9f932ad-de0d-44ca-bf35-ae8184f63909', 'DED830049306'],
  ['c983b62d-f528-433f-a402-a6317ce3d2d8', 'DED830049307'],
  ['9d50b06a-4136-427f-8d11-b2efb0141da6', 'DED830049308'],
  ['f2af3e3f-3f9f-4f8d-8b60-1d1b709aaf69', 'DED830049309'],
  ['059384bc-fb45-445e-ab77-950d6ccf587a', 'DED830049310'],
  ['2f4d7b47-a4ba-495a-b447-60b8287ed9c9', 'DED830049311'],
])

puts "ISRCs submitted."
