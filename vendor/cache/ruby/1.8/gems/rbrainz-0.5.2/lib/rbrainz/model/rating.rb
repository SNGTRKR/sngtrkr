# -*- coding: utf-8 -*-
# $Id: rating.rb 273 2009-05-24 22:29:04Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2008 Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Model

    #
    # Represents a rating of an entity.
    # 
    # MusicBrainz allows it's users to rate artists, labels, releases and tracks.
    # Each user rating will be a Float between 1 and 5 or nil, where nil means no rating.
    # The system will aggregate user ratings to compute the average community rating. 
    # 
    # See:: http://wiki.musicbrainz.org/RatingSystem
    class Rating
      # The rating (an Float between 1 and 5).
      # If :count is greater than 1 this will be the average rating. 
      attr_accessor :value

      # The rating count indicating how often entity was rated.
      attr_accessor :count
      
      def initialize(value=nil, count=nil)
        @value = value.nil? ? nil : value.to_f
        @count = count.nil? ? nil : count.to_i
      end
      
      # Convert this rating into a String. Will return rating.
      def to_s
        return value.to_s
      end
      
      # Convert this rating into an Integer. Will return rating.
      def to_i
        return value.to_i
      end
      
      # Convert this rating into a Float. Will return rating.
      def to_f
        return value.to_f
      end
      
      # Tests if this rating is empty
      def empty?
        return value.nil?
      end
      
    end

  end
end
