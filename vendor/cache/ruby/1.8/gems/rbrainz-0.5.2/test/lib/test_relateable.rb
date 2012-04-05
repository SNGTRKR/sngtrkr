# -*- coding: utf-8 -*-
# $Id: test_relateable.rb 254 2009-05-13 20:04:36Z phw $
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
# tests on entities which include the Relateable mixin.
# The tests should be executed by all subclass tests.
module TestRelateable

  def test_relations
    entity = @tested_class.new
    
    # Create some test relations
    artist_rel = Model::Relation.new
    artist_rel.target = Model::Artist.new
    artist_rel.type = Model::NS_REL_1 + 'Vocal'
    artist_rel.direction = Model::Relation::DIR_BACKWARD
    artist_rel.attributes << Model::NS_REL_1 + 'Guest'
    artist_rel.attributes << Model::NS_REL_1 + 'Lead'
    assert_nothing_raised {entity.add_relation artist_rel}
    
    track_rel = Model::Relation.new
    track_rel.target = Model::Track.new
    track_rel.type = Model::NS_REL_1 + 'Vocal'
    track_rel.direction = Model::Relation::DIR_FORWARD
    track_rel.attributes << Model::NS_REL_1 + 'Lead'
    track_rel.attributes << Model::NS_REL_1 + 'Guest'
    assert_nothing_raised {entity.add_relation track_rel}
    
    url_rel = Model::Relation.new
    url_rel.target = 'http://www.example.com'
    url_rel.type = Model::NS_REL_1 + 'OfficialHomepage'
    assert_nothing_raised {entity.add_relation url_rel}
    
    # Get all relations
    rel_list = []
    assert_nothing_raised {rel_list = entity.get_relations()}
    assert_equal 3, rel_list.size
    assert rel_list.include?(artist_rel)
    assert rel_list.include?(track_rel)
    assert rel_list.include?(url_rel)
  
    # Get only artist relation by target type
    assert_nothing_raised {rel_list = entity.get_relations(
                             :target_type => Model::Relation::TO_ARTIST)}
    assert_equal 1, rel_list.size
    assert rel_list.include?(artist_rel)
    
    # Get only artist relation by target type (without namespace)
    assert_nothing_raised {rel_list = entity.get_relations(
                             :target_type => 'Artist')}
    assert_equal 1, rel_list.size
    assert rel_list.include?(artist_rel)
    
    # Get only url relation type
    assert_nothing_raised {rel_list = entity.get_relations(
                             :relation_type => Model::NS_REL_1 + 'OfficialHomepage')}
    assert_equal 1, rel_list.size
    assert rel_list.include?(url_rel)
    
    # Get only url relation type (without namespace)
    assert_nothing_raised {rel_list = entity.get_relations(
                             :relation_type => 'OfficialHomepage')}
    assert_equal 1, rel_list.size
    assert rel_list.include?(url_rel)
    
    # Get only artist and track relation by attribute
    assert_nothing_raised {rel_list = entity.get_relations(
                             :required_attributes => ['Guest', Model::NS_REL_1 + 'Lead'])}
    assert_equal 2, rel_list.size
    assert rel_list.include?(artist_rel)
    assert rel_list.include?(track_rel)
    
    # Get only artist relation by target type
    assert_nothing_raised {rel_list = entity.get_relations(
                             :direction => Model::Relation::DIR_BACKWARD)}
    assert_equal 1, rel_list.size
    assert rel_list.include?(artist_rel)
    
    # Test the target types
    target_types = entity.relation_target_types
    assert_equal 3, target_types.size, target_types.inspect
    [Model::Relation::TO_ARTIST, Model::Relation::TO_TRACK,
     Model::Relation::TO_URL].each {|type|
      assert target_types.include?(type), target_types.inspect
    }
  end
  
  def test_no_direct_acces_to_relations
    entity = @tested_class.new
    assert_raise(NoMethodError) { entity.relations }
  end
  
end
