# -*- coding: utf-8 -*-
# $Id: taggable.rb 321 2011-04-19 22:04:41Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/tag'

module MusicBrainz
  module Model

    # Mixin module to add folksonomy tagging capabilities to Entity classes.
    #
    # see:: Tag
    module Taggable
      
      # Returns a Collection of Tag objects assigned to this entity.
      def tags
        @tags ||= Collection.new
      end

      # Returns a Collection of Tag objects assigned to this entity by the current user.
      def user_tags
        @user_tags ||= Collection.new
      end
      
    end
      
  end
end
