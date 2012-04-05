# -*- coding: utf-8 -*-
# $Id: isrc.rb 263 2009-05-24 22:15:12Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Model

    # The format of a ISRC was wrong.
    # 
    # See:: ISRC
    class InvalidISRCError < Exception
    end

    #
    # Represents an International Standard Recording Code (ISRC).
    # 
    # The International Standard Recording Code or short ISRC is an identification
    # system for audio and music video recordings. It is standarized by the IFPI
    # in ISO 3901:2001 and used by IFPI members to assign unique identifiers to
    # every distinct recording they release. 
    # 
    # See:: http://wiki.musicbrainz.org/ISRC
    class ISRC
      
      ISRC_PATTERN = /^([0-9A-Z]{2})-?([0-9A-Z]{3})-?([0-9A-Z]{2})-?([0-9A-Z]{5})$/i
      
      # 2-letter country code according to the ISO 3166-1-Alpha-2 standard.
      attr_reader :country
      
      # The Registrant Code identifies the entity assigning the Designation Code in an ISRC.
      attr_reader :registrant
      
      # Year of reference (2 digits).
      attr_reader :year
      
      # Designation code (5 digits)
      attr_reader :designation
      
      # Tries to convert _obj_ into an ISRC object.
      # 
      # If _obj_ is an ISRC it is returned. Otherwise a new ISRC object
      # is created by converting _obj_ into a string and parsing it.
      # 
      # Raises:: InvalidISRCError
      def self.parse(obj)
        if obj.is_a? ISRC
          return obj
        else
          return ISRC.new(obj)
        end
      end
      
      # Create a new ISRC object from the given string.
      #
      # Raises:: InvalidISRCError
      def initialize(isrc)
        unless isrc.to_s =~ ISRC_PATTERN
          raise InvalidISRCError
        end
        @country = $1.upcase
        @registrant = $2.upcase
        @year = $3.upcase
        @designation = $4.upcase
      end   

      # Convert this ISRC into a String.
      # Will return the readable version of the ISRC with dashes added,
      # e.g. FR-Z03-91-01231
      def to_s
        return [@country, @registrant, @year, @designation].join('-')
      end
      
      # Convert this ISRC into a String.
      # Will return the 12 character representation of the ISRC without dashes,
      # e.g. FRZ039101231
      def to_str
        return [@country, @registrant, @year, @designation].join
      end
      
      # Compares this ISRC with another one.
      # 
      # If _other_ is not of the type ISRC an attempt is made to convert it into one.
      # This may cause an InvalidISRCError to be raised. Please note that
      # comparing an ISRC with a different type of object is usually
      # not commutative.
      #
      # Raises:: InvalidISRCError
      def eql?(other)
        self.to_s == ISRC.parse(other).to_s
      end
      alias :== eql?
      
    end

  end
end
