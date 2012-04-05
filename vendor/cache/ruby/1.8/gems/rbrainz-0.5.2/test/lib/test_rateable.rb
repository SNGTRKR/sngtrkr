# -*- coding: utf-8 -*-
# $Id: test_rateable.rb 285 2009-08-04 12:00:34Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2009, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the entity model.
# This is only a test module which defines general
# tests on entities which include the Rateable mixin.
# The tests should be executed by all subclass tests.
module TestRateable

  def test_class_has_empty_rating
    entity = @tested_class.new
    assert entity.rating.is_a?(Model::Rating)
    assert entity.rating.empty?
  end

  def test_class_has_empty_user_rating
    entity = @tested_class.new
    assert entity.user_rating.is_a?(Model::Rating)
    assert entity.user_rating.empty?
  end
  
end
