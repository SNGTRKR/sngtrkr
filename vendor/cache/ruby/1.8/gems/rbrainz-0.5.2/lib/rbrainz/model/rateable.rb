# -*- coding: utf-8 -*-
# $Id: rateable.rb 266 2009-05-24 22:15:22Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/rating'

module MusicBrainz
  module Model

    # Mixin module to add rating capabilities to Entity classes.
    #
    # see:: Rating
    module Rateable
      
      # The community Rating from MusicBrainz.
      def rating
        @rating ||= Rating.new
      end
      attr_writer :rating
      
      # The user Rating from MusicBrainz.
      def user_rating
        @user_rating ||= Rating.new
      end
      attr_writer :user_rating
      
    end
      
  end
end
