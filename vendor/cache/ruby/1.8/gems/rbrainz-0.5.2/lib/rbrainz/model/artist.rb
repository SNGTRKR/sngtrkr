# -*- coding: utf-8 -*-
# $Id: artist.rb 258 2009-05-17 17:43:58Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/individual'

module MusicBrainz
  module Model

    #
    # An artist in the MusicBrainz DB.
    #
    # Artists in MusicBrainz can have a type. Currently, this type can
    # be either Person or Group for which the following URIs are assigned:
    #
    # - http://musicbrainz.org/ns/mmd-1.0#Person
    # - http://musicbrainz.org/ns/mmd-1.0#Group
    #
    # Use the TYPE_PERSON and TYPE_GROUP constants for comparison.
    #
    # See:: Individual
    # See:: http://musicbrainz.org/doc/Artist.
    class Artist < Individual
    
      # Used if the type of the artist is unknown.
      TYPE_UNKNOWN = NS_MMD_1 + 'Unknown'
      # This indicates an individual person.
      TYPE_PERSON  = NS_MMD_1 + 'Person'
      # This indicates a group of people that may or may
      # not have a distinctive name.
      TYPE_GROUP   = NS_MMD_1 + 'Group'
    
      # See Entity::ENTITY_TYPE.
      ENTITY_TYPE = :artist # :nodoc:
      
      # A Collection of release groups of this artist.
      attr_reader :release_groups
      
      def initialize(id=nil, type=nil, name=nil, sort_name=nil)
        super id, type, name, sort_name
        @release_groups = Collection.new
      end
      
    end

  end
end
