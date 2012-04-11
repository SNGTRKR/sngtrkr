# -*- coding: utf-8 -*-
# $Id: default_factory.rb 273 2009-05-24 22:29:04Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/artist'
require 'rbrainz/model/label'
require 'rbrainz/model/release_group'
require 'rbrainz/model/release'
require 'rbrainz/model/track'
require 'rbrainz/model/user'

module MusicBrainz
  module Model

    # A factory to create model classes.
    class DefaultFactory
      
      # Creates a new entity for a given entity type (<tt>:artist</tt>,
      # <tt>:label</tt>, <tt>:release</tt> or <tt>:track</tt>).
      def new_entity(entity_type)
        case entity_type
          when Artist.entity_type
            new_artist
          when Label.entity_type
            new_label
          when ReleaseGroup.entity_type
            new_release_group
          when Release.entity_type
            new_release
          when Track.entity_type
            new_track
        end
      end
      
      def new_artist
        Artist.new
      end
      
      def new_label
        Label.new
      end
      
      def new_release_group
        ReleaseGroup.new
      end
      
      def new_release
        Release.new
      end
      
      def new_track
        Track.new
      end
      
      def new_alias
        Alias.new
      end
      
      def new_disc
        Disc.new
      end
      
      def new_relation
        Relation.new
      end
      
      def new_release_event
        ReleaseEvent.new
      end
      
      def new_tag
        Tag.new
      end
      
      def new_rating
        Rating.new
      end
      
      def new_user
        User.new
      end
      
    end
    
  end
end
