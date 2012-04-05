# -*- coding: utf-8 -*-
# $Id: test_entity.rb 254 2009-05-13 20:04:36Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the entity model.
# This is only a test module which defines general
# tests on Entity. The tests should be executed by
# all subclass tests.
module TestEntity

  def test_valid_mbid
    entity = @tested_class.new
    valid_mbid = Model::MBID.parse('9d30e408-1559-448b-b491-2f8de1583ccf', @tested_class.entity_type )
    
    assert_equal nil, entity.id
    assert_nothing_raised {entity.id = valid_mbid}
    assert_equal valid_mbid, entity.id
  end
  
  def test_valid_mbid_from_uuid
    entity = @tested_class.new
    valid_mbid = Model::MBID.parse('9d30e408-1559-448b-b491-2f8de1583ccf', @tested_class.entity_type )
    
    assert_equal nil, entity.id
    assert_nothing_raised {entity.id = valid_mbid.uuid}
    assert_equal valid_mbid, entity.id
  end
  
  def test_valid_mbid_from_uri
    entity = @tested_class.new
    valid_mbid = Model::MBID.parse( '9d30e408-1559-448b-b491-2f8de1583ccf', @tested_class.entity_type )
    
    assert_equal nil, entity.id
    assert_nothing_raised {entity.id = valid_mbid.to_s}
    assert_equal valid_mbid, entity.id
  end
  
  def test_invalid_mbid_entity_type_not_matching
    entity = @tested_class.new
    @invalid_entity_types.each {|type|
      invalid_mbid = Model::MBID.parse( '9d30e408-1559-448b-b491-2f8de1583ccf', type )
      assert_raise(Model::EntityTypeNotMatchingError) {entity.id = invalid_mbid}
      assert_raise(Model::EntityTypeNotMatchingError) {entity.id = invalid_mbid.to_s}
    }
    assert_equal nil, entity.id
  end

end
