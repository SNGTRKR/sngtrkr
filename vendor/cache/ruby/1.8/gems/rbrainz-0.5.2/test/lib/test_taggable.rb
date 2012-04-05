# -*- coding: utf-8 -*-
# $Id: test_taggable.rb 254 2009-05-13 20:04:36Z phw $
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
# tests on entities which include the Taggable mixin.
# The tests should be executed by all subclass tests.
module TestTaggable

  def test_tags
    entity = @tested_class.new
    tag1 = Model::Tag.new('doom metal')
    tag2 = Model::Tag.new
    
    assert_equal 0, entity.tags.size
    assert_nothing_raised {entity.tags << tag1}
    assert_equal 1, entity.tags.size
    assert_nothing_raised {entity.tags << tag2}
    assert_equal 2, entity.tags.size
    
    assert_nothing_raised {entity.tags.delete tag2}
    assert_equal 1, entity.tags.size
    assert_nothing_raised {entity.tags.delete tag1}
    assert_equal 0, entity.tags.size
  end
  
end
