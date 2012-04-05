#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Example script showing the use of ratings with RBrainz.
# It asks the user for his username and password and a MBID and queries the
# MusicBrainz server for the rating, the user has applied to the entitity with
# the given MBID. Afterwards the user can submit a new rating.
# 
# $Id: rate.rb 273 2009-05-24 22:29:04Z phw $

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

# Ask for a MBID to tag. The MBID must be a complete MusicBrainz identifier,
# e.g. http://musicbrainz.org/release/6785cad0-159c-40ec-9ee4-30d8745dd7f9
print 'Enter a MBID: '
mbid = Model::MBID.new(STDIN.gets.strip)

# Set the authentication for the webservice.
ws = Webservice::Webservice.new(:username=>username, :password=>password) 

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new(ws, :client_id => 'RBrainz test ' + RBRAINZ_VERSION)

# Read and print the current rating for the given MBID.
rating = query.get_user_rating(mbid)
print "Current rating: #{rating.to_s}"

# Ask the user for a new rating and submit it.
print 'Enter new rating: '
new_rating = STDIN.gets.strip
query.submit_user_rating(mbid, new_rating.to_i)
