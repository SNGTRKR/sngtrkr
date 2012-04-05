# -*- coding: utf-8 -*-
# $Id: entity.rb 254 2009-05-13 20:04:36Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
 
require 'rbrainz/model/mbid'

module MusicBrainz
  module Model

    #
    # A first-level MusicBrainz class.
    # 
    # All entities in MusicBrainz have unique IDs (which are MBID's representing
    # absolute URIs) and may have any number of #relations to other entities.
    # This class is abstract and should not be instantiated.
    # 
    # Relations are differentiated by their <i>target type</i>, that means,
    # where they link to. MusicBrainz currently supports four target types
    # (artists, releases, tracks, and URLs) each identified using a URI.
    # To get all relations with a specific target type, you can use
    # #relations and pass one of the following constants as the
    # parameter:
    #
    # - Relation::TO_ARTIST
    # - Relation::TO_RELEASE
    # - Relation::TO_TRACK
    # - Relation::TO_URL
    #
    # See:: Relation
    #
    class Entity
      
      # The entity type of this entity. Must be set by child classes correctly.
      # 
      # Use #entity_type to query the type.
      ENTITY_TYPE = nil # :nodoc:
      
      # The MusicBrainz ID. A MBID containing an absolute URI.
      attr_reader :id
      
      # Create a new Entity. You can assign a MusicBrainz identifier to the
      # created entity with the parameter _mbid_ (see id=).
      def initialize(mbid=nil)
        self.id = mbid
      end
      
      # Set the MBID.
      # 
      # _mbid_ should be an instance of MBID or a string
      # representing either a complete MBID URI or just the
      # UUID part of it. If it is a complete URI the entity
      # part of the URI must match the entity type returned
      # by +entity_type+ or an EntityTypeNotMatchingError
      # will be raised.
      # 
      # Raises: UnknownEntityError, InvalidMBIDError,
      # EntityTypeNotMatchingError
      def id=(mbid)
        if mbid
          @id = MBID.parse(mbid, entity_type)
        else
          @id = nil
        end
      end
      
      # Returns the entity type of the entity class.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def self.entity_type
        self::ENTITY_TYPE
      end
      
      # Returns the entity type of the instance.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def entity_type
        self.class.entity_type
      end
      
    end
    
  end
end
