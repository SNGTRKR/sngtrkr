# -*- coding: utf-8 -*-
# $Id: release_group.rb 269 2009-05-24 22:15:27Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/release'

module MusicBrainz
  module Model

    #
    # A release group in the MusicBrainz DB.
    #
    # A release group within MusicBrainz is an Entity which groups several
    # different versions of releases (e.g. different editions of the same album).
    #
    # See:: http://wiki.musicbrainz.org/Release_Groups
    class ReleaseGroup < Entity
      
      # A type for not a type. Currently unsupported by MusicBrainz
      TYPE_NONE           = NS_MMD_1 + 'None'
      
      # Special type for release groups that hold non-album track releases.
      TYPE_NON_ALBUM_TRACKS = NS_MMD_1 + 'NonAlbum Track'
      
      # An album, perhaps better defined as a "Long Play" (LP) release,
      # generally consists of previously unreleased material. This includes
      # release re-issues, with or without bonus tracks.
      TYPE_ALBUM          = NS_MMD_1 + 'Album'
      # An audiobook is a book read by a narrator without music.
      TYPE_AUDIOBOOK      = NS_MMD_1 + 'Audiobook'
      # A compilation is a collection of previously released tracks by one or
      # more artists. Please note that this is a simplified description of a
      # compilation.
      TYPE_COMPILATION    = NS_MMD_1 + 'Compilation'
      # An EP is a so-called "Extended Play" release and often contains the
      # letters EP in the title.
      TYPE_EP             = NS_MMD_1 + 'EP'
      # An interview release contains an interview, generally with an Artist.
      TYPE_INTERVIEW      = NS_MMD_1 + 'Interview'
      # A release that was recorded live.
      TYPE_LIVE           = NS_MMD_1 + 'Live'
      # A release that primarily contains remixed material.
      TYPE_REMIX          = NS_MMD_1 + 'Remix'
      # A single typically has one main song and possibly a handful of
      # additional tracks or remixes of the main track. A single is usually
      # named after its main song.
      TYPE_SINGLE         = NS_MMD_1 + 'Single'
      # A soundtrack is the musical score to a movie, TV series, stage show,
      # computer game etc.
      TYPE_SOUNDTRACK     = NS_MMD_1 + 'Soundtrack'
      # Non-music spoken word releases.
      TYPE_SPOKENWORD     = NS_MMD_1 + 'Spokenword'
      # Any release that does not fit or can't decisively be placed in any of
      # the categories above.
      TYPE_OTHER          = NS_MMD_1 + 'Other'
      
      # See Entity::ENTITY_TYPE.
      ENTITY_TYPE = :release_group # :nodoc:
      
      # The title of this release group.
      attr_accessor :title
      
      # A Collection of releases in this release group.
      attr_reader :releases
      
      # The artist of this release group.
      attr_accessor :artist
      
      # The list of types for this release.
      #
      # To test for release types, you can use the constants
      # TYPE_ALBUM, TYPE_SINGLE, etc.
      attr_reader :types
      
      def initialize(id=nil, title=nil)
        super id
        @title = title
        @releases = Collection.new
        @types = Array.new
      end
      
      # Returns the string representation for this release group.
      # 
      # Returns #title converted into a string.
      def to_s
        title.to_s
      end
        
    end
  
  end
end
