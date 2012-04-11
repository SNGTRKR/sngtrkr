# -*- coding: utf-8 -*-
# $Id: relateable.rb 286 2009-08-04 12:03:43Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'set'
require 'rbrainz/model/relation'
require 'rbrainz/model/collection'

module MusicBrainz
  module Model

    # Mixin module to add add advanced relationship capabilities to Entity classes.
    #
    # see:: Relation
    module Relateable
      
      #
      # Adds a Relation.
      #
      # This method adds _relation_ to the list of relations. The
      # given relation has to be initialized, at least the target
      # type has to be set.
      #
      def add_relation(relation)
        relations[relation.target_type] << relation
      end
      
      #
      # Returns a list of Relation objects.
      #
      # If _target_type_ is given, only relations of that target
      # type are returned. For MusicBrainz, the following target
      # types are defined:
      # - Relation::TO_ARTIST
      # - Relation::TO_RELEASE
      # - Relation::TO_TRACK
      # - Relation::TO_URL
      # 
      # If _target_type_ is Relation::TO_ARTIST, for example,
      # this method returns all relations between this Entity and
      # artists.
      #
      # You may use the _relation_type_ parameter to further restrict
      # the selection. If it is set, only relations with the given
      # relation type are returned. The _required_attributes_ sequence
      # lists attributes that have to be part of all returned relations.
      #
      # If _direction_ is set, only relations with the given reading
      # direction are returned. You can use the Relation::DIR_FORWARD,
      # Relation::DIR_BACKWARD, and Relation::DIR_BOTH constants
      # for this.
      #
      def get_relations(options = {:target_type => nil, :relation_type => nil,
                                   :required_attributes => [], :direction => nil})
        Utils.check_options options, 
            :target_type, :relation_type, :required_attributes, :direction
        
        target_type   = Utils.add_namespace(options[:target_type], NS_REL_1)
        relation_type = Utils.add_namespace(options[:relation_type], NS_REL_1)
        required_attributes = 
          options[:required_attributes] ? options[:required_attributes] : []
        direction = options[:direction]
        
        # Select all relevant relations depending on the requested target type
        if target_type
          result = relations[target_type].to_a
        else
          result = relations.values.flatten
        end
        
        # Filter for direction
        result = result.find_all { |r| r.direction == direction } if direction
        
        # Filter for relation type
        result = result.find_all{ |r| r.type == relation_type } if relation_type
        
        # Filter for attributes
        required = required_attributes.map{|a| Utils.add_namespace(a, NS_REL_1)}.to_set
        result.find_all do |r|
             required.subset?( r.attributes.to_set )
        end
      end
      
      #
      # Returns a list of target types available for this entity.
      # 
      # Use this to find out to which types of targets this entity
      # has relations. If the entity only has relations to tracks and
      # artists, for example, then a list containg the strings
      # Relation::TO_TRACK and Relation::TO_ARTIST is returned.
      #
      def relation_target_types
        result = []
        relations.each_pair {|type, relations|
          result << type unless relations.empty?
        }
        return result
      end
      
      private #-----------------------------------------------------------------
      
      def relations
        @relations ||= {
          Relation::TO_ARTIST  => Collection.new,
          Relation::TO_RELEASE => Collection.new,
          Relation::TO_TRACK   => Collection.new,
          Relation::TO_LABEL   => Collection.new,
          Relation::TO_URL     => Collection.new,
        }
      end
      
    end
      
  end
end
